<script lang="ts">
	import { onMount } from 'svelte';
	import '../app.css';
	import {
		pollServices,
		initialServiceStates,
		deriveSystemStatus,
		formatTime
	} from '$lib/health.js';
	import type { ServiceHealth, SystemStatus } from '$lib/types.js';

	// ----- Svelte 5 runes state -----
	let services: ServiceHealth[] = $state(initialServiceStates());
	let countdown: number = $state(30);
	// Plain let — isPolling is a concurrency guard, not displayed in the UI
	let isPolling = false;

	// Derived system-wide status (synchronous transform — NOT async)
	let systemStatus: SystemStatus = $derived(deriveSystemStatus(services));

	// ----- Polling setup -----
	// Use onMount (not $effect) so the polling loop runs once on mount and never
	// re-triggers due to reactive state changes. $effect re-runs whenever its
	// tracked dependencies change, which would cancel in-flight polls via the
	// cleanup function before services = updated can fire.
	onMount(() => {
		let cancelled = false;

		async function poll() {
			if (isPolling) return;
			isPolling = true;
			console.log('[poll] starting');
			try {
				const updated = await pollServices('', services);
				console.log('[poll] got results:', updated.map(s => s.status));
				if (!cancelled) {
					console.log('[poll] assigning services, cancelled=', cancelled);
					services = updated;
					console.log('[poll] services assigned, first status=', services[0]?.status);
				}
			} catch (e) {
				console.error('[poll] error:', e);
			} finally {
				if (!cancelled) isPolling = false;
			}
		}

		// Immediate first poll
		poll();

		// Countdown + periodic poll every 30s
		countdown = 30;
		const tick = setInterval(() => {
			if (!cancelled) {
				countdown = countdown <= 1 ? 30 : countdown - 1;
			}
		}, 1000);

		const interval = setInterval(() => {
			if (!cancelled) {
				countdown = 30;
				poll();
			}
		}, 30_000);

		// Cleanup on component destroy
		return () => {
			cancelled = true;
			clearInterval(tick);
			clearInterval(interval);
		};
	});

	// ----- UI helpers -----
	function statusDotClass(status: string): string {
		switch (status) {
			case 'healthy':
				return 'status-dot status-dot-healthy';
			case 'degraded':
				return 'status-dot status-dot-degraded';
			case 'error':
				return 'status-dot status-dot-error';
			default:
				return 'status-dot status-dot-unknown';
		}
	}

	function cardBorderClass(status: string): string {
		switch (status) {
			case 'healthy':
				return 'border-green-500/40';
			case 'degraded':
			case 'error':
				return 'border-amber-400';
			default:
				return 'border-gray-600';
		}
	}

	function systemStatusLabel(s: SystemStatus): string {
		switch (s) {
			case 'all-healthy':
				return 'All Systems Operational';
			case 'degraded':
				return 'Degraded';
			case 'connecting':
				return 'Connecting...';
		}
	}

	function systemStatusBadgeClass(s: SystemStatus): string {
		switch (s) {
			case 'all-healthy':
				return 'bg-green-900/50 text-green-300 border border-green-600';
			case 'degraded':
				return 'bg-amber-900/50 text-amber-300 border border-amber-600';
			case 'connecting':
				return 'bg-gray-700 text-gray-300 border border-gray-600';
		}
	}

	function truncateSha(sha: string | undefined): string {
		if (!sha) return '--';
		return sha.length > 8 ? sha.slice(0, 8) : sha;
	}
</script>

<div class="min-h-screen bg-gray-950 text-gray-100">
	<!-- Header -->
	<header class="border-b border-gray-800 bg-gray-900 px-6 py-4">
		<div class="mx-auto flex max-w-6xl items-center justify-between">
			<div>
				<h1 class="text-xl font-bold tracking-tight text-white">
					Agentic DevOps Reference App
				</h1>
				<p class="mt-0.5 text-sm text-gray-400">Service Health Dashboard</p>
			</div>

			<div class="flex items-center gap-4">
				<!-- System status badge -->
				<span
					class="rounded-full px-3 py-1 text-sm font-medium {systemStatusBadgeClass(systemStatus)}"
					class:animate-pulse-slow={systemStatus === 'connecting'}
				>
					{systemStatusLabel(systemStatus)}
				</span>

				<!-- Auto-refresh countdown -->
				<div class="text-right text-xs text-gray-500">
					<div>Auto-refresh in</div>
					<div class="font-mono text-base text-gray-300">{countdown}s</div>
				</div>
			</div>
		</div>
	</header>

	<!-- Main content -->
	<main class="mx-auto max-w-6xl px-6 py-8">
		{#if systemStatus === 'connecting'}
			<!-- Connecting state — all services unknown -->
			<div class="mb-8 flex flex-col items-center justify-center py-12 text-gray-500">
				<div
					class="mb-4 h-8 w-8 animate-spin rounded-full border-2 border-gray-600 border-t-blue-500"
				></div>
				<p class="text-lg">Connecting to services...</p>
				<p class="mt-1 text-sm">First poll in progress</p>
			</div>
		{/if}

		<!-- Service cards grid: 1 col mobile, 3 col desktop -->
		<div class="grid gap-6 sm:grid-cols-1 lg:grid-cols-3">
			{#each services as svc (svc.name)}
				<div
					class="rounded-xl border bg-gray-900 p-5 shadow-lg transition-colors {cardBorderClass(svc.status)}"
				>
					<!-- Card header: service name + status indicator -->
					<div class="mb-4 flex items-center justify-between">
						<div class="flex items-center">
							<span class={statusDotClass(svc.status)}></span>
							<h2 class="text-base font-semibold text-white">{svc.displayName}</h2>
						</div>
						<span class="text-xs text-gray-500">:{svc.port}</span>
					</div>

					{#if svc.status === 'degraded' || svc.status === 'error'}
						<!-- Degraded state: show warning, not crash -->
						<div class="mb-4 rounded-lg bg-amber-900/30 px-3 py-2 text-sm text-amber-300">
							Service Unavailable — showing last known state
						</div>
					{/if}

					<!-- Version info (D-04: visible version that changes on deploy) -->
					<div class="mb-3 space-y-1.5">
						<div class="flex justify-between text-sm">
							<span class="text-gray-400">version</span>
							<span class="font-mono text-gray-200">{svc.version ?? '--'}</span>
						</div>
						<div class="flex justify-between text-sm">
							<span class="text-gray-400">git sha</span>
							<span class="font-mono text-xs text-gray-300">{truncateSha(svc.gitSha)}</span>
						</div>
						<div class="flex justify-between text-sm">
							<span class="text-gray-400">latency</span>
							<span class="font-mono text-gray-200">
								{svc.latencyMs != null ? `${svc.latencyMs}ms` : '--'}
							</span>
						</div>
						<div class="flex justify-between text-sm">
							<span class="text-gray-400">last checked</span>
							<span class="font-mono text-xs text-gray-400">{formatTime(svc.lastChecked)}</span>
						</div>
					</div>

					<!-- api-gateway downstream dependency status -->
					{#if svc.name === 'api-gateway' && svc.details != null}
						<div class="mt-4 border-t border-gray-700 pt-3">
							<p class="mb-2 text-xs font-medium uppercase tracking-wider text-gray-500">
								Downstream
							</p>
							<div class="flex gap-3">
								<span
									class="flex items-center gap-1 rounded px-2 py-0.5 text-xs {svc.details.catalog
										? 'bg-green-900/40 text-green-300'
										: 'bg-amber-900/40 text-amber-300'}"
								>
									<span
										class="status-dot {svc.details.catalog
											? 'status-dot-healthy'
											: 'status-dot-degraded'}"
										style="width:6px;height:6px"
									></span>
									catalog
								</span>
								<span
									class="flex items-center gap-1 rounded px-2 py-0.5 text-xs {svc.details.worker
										? 'bg-green-900/40 text-green-300'
										: 'bg-amber-900/40 text-amber-300'}"
								>
									<span
										class="status-dot {svc.details.worker
											? 'status-dot-healthy'
											: 'status-dot-degraded'}"
										style="width:6px;height:6px"
									></span>
									worker
								</span>
							</div>
						</div>
					{/if}
				</div>
			{/each}
		</div>

		<!-- Footer note -->
		<p class="mt-8 text-center text-xs text-gray-600">
			Polls every 30s &middot; 3s timeout per service &middot; degraded = service unreachable (not a
			crash)
		</p>
	</main>
</div>
