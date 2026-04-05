<script lang="ts">
	import { onMount } from 'svelte';
	import '../app.css';
	import {
		pollServices,
		initialServiceStates,
		deriveSystemStatus,
		formatTime,
		fetchCatalogItems,
		fetchRecentEvents,
		fetchDatabaseStatus,
		timeAgo
	} from '$lib/health.js';
	import type { CatalogItem, ServiceHealth, ServiceStatus, SystemStatus, WorkerEvent } from '$lib/types.js';

	// ----- Svelte 5 runes state -----
	let services: ServiceHealth[] = $state(initialServiceStates());
	let catalogItems: CatalogItem[] = $state([]);
	let recentEvents: WorkerEvent[] = $state([]);
	let dbStatus: ServiceStatus = $state('unknown');
	let countdown: number = $state(30);
	// Plain let — isPolling is a concurrency guard, not displayed in the UI
	let isPolling = false;

	// Derived system-wide status (synchronous transform — NOT async)
	let systemStatus: SystemStatus = $derived(deriveSystemStatus(services));

	// ----- Polling setup -----
	onMount(() => {
		let cancelled = false;

		async function poll() {
			if (isPolling) return;
			isPolling = true;
			try {
				const [updated, items, events, dbSt] = await Promise.all([
					pollServices('', services),
					fetchCatalogItems(),
					fetchRecentEvents(),
					fetchDatabaseStatus()
				]);
				if (!cancelled) {
					services = updated;
					dbStatus = dbSt;
					if (items.length > 0) catalogItems = items;
					if (events.length > 0) recentEvents = events;
				}
			} catch (e) {
				console.error('[poll] error:', e);
			} finally {
				if (!cancelled) isPolling = false;
			}
		}

		poll();

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

	function itemStatusClass(status: string): string {
		switch (status) {
			case 'active':
				return 'bg-green-900/40 text-green-300 border border-green-700';
			case 'degraded':
				return 'bg-amber-900/40 text-amber-300 border border-amber-700';
			case 'maintenance':
				return 'bg-blue-900/40 text-blue-300 border border-blue-700';
			default:
				return 'bg-gray-800 text-gray-400 border border-gray-600';
		}
	}

	function eventBadgeClass(eventType: string): string {
		switch (eventType) {
			case 'deploy':
				return 'bg-blue-900/50 text-blue-300';
			case 'heartbeat':
				return 'bg-gray-700 text-gray-400';
			case 'alert':
				return 'bg-red-900/50 text-red-300';
			case 'health_check':
				return 'bg-green-900/50 text-green-300';
			default:
				return 'bg-gray-700 text-gray-400';
		}
	}

	// Topology: compute node colour from a ServiceStatus value
	function statusStroke(status: ServiceStatus): string {
		if (status === 'healthy') return '#22c55e'; // green-500
		if (status === 'degraded' || status === 'error') return '#f59e0b'; // amber-400
		return '#4b5563'; // gray-600 (unknown)
	}

	function statusFill(status: ServiceStatus): string {
		if (status === 'healthy') return '#052e16'; // green-950
		if (status === 'degraded' || status === 'error') return '#451a03'; // amber-950
		return '#1f2937'; // gray-800 (unknown)
	}

	function statusLine(status: ServiceStatus): string {
		if (status === 'healthy') return '#166534'; // green-800
		if (status === 'degraded' || status === 'error') return '#92400e'; // amber-800
		return '#374151'; // gray-700 (unknown)
	}

	// Helpers: look up live status for a named service then map to colour
	function nodeStroke(serviceName: string): string {
		const svc = services.find((s) => s.name === serviceName);
		return statusStroke(svc?.status ?? 'unknown');
	}

	function nodeFill(serviceName: string): string {
		const svc = services.find((s) => s.name === serviceName);
		return statusFill(svc?.status ?? 'unknown');
	}

	function lineStroke(fromService: string): string {
		const svc = services.find((s) => s.name === fromService);
		return statusLine(svc?.status ?? 'unknown');
	}

	function payloadSummary(payload: Record<string, unknown>): string {
		const keys = Object.keys(payload);
		if (keys.length === 0) return '';
		// Show the most useful key: prefer message, reason, service, version
		for (const k of ['message', 'reason', 'service', 'version', 'status']) {
			if (payload[k]) return String(payload[k]);
		}
		return `${keys[0]}: ${String(payload[keys[0]])}`;
	}
</script>

<div class="min-h-screen bg-gray-950 text-gray-100">
	<!-- Header -->
	<header class="border-b border-gray-800 bg-gray-900 px-6 py-4">
		<div class="mx-auto flex max-w-6xl items-center justify-between">
			<div>
				<h1 class="text-xl font-bold tracking-tight text-white">
					NovaDeploy
				</h1>
				<p class="mt-0.5 text-sm text-gray-400">Platform Operations Console</p>
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
			<div class="mb-8 flex flex-col items-center justify-center py-8 text-gray-500">
				<div
					class="mb-4 h-8 w-8 animate-spin rounded-full border-2 border-gray-600 border-t-blue-500"
				></div>
				<p class="text-lg">Connecting to services...</p>
				<p class="mt-1 text-sm">First poll in progress</p>
			</div>
		{/if}

		<!-- ── Service Topology ── -->
		<section class="mb-8">
			<h2 class="mb-3 text-xs font-semibold uppercase tracking-widest text-gray-500">
				Service Topology
			</h2>
			<div class="rounded-xl border border-gray-800 bg-gray-900 p-4">
				<svg
					viewBox="0 0 680 260"
					class="w-full"
					aria-label="Service topology diagram"
				>
					<!-- ── Connecting lines (drawn before nodes so nodes sit on top) ── -->

					<!-- Dashboard → API Gateway -->
					<line x1="340" y1="52" x2="340" y2="108" stroke={lineStroke('api-gateway')} stroke-width="1.5" stroke-dasharray="4 3" />

					<!-- API Gateway → Catalog -->
					<line x1="285" y1="138" x2="175" y2="168" stroke={lineStroke('catalog')} stroke-width="1.5" />

					<!-- API Gateway → Worker -->
					<line x1="395" y1="138" x2="505" y2="168" stroke={lineStroke('worker')} stroke-width="1.5" />

					<!-- Catalog → Postgres -->
					<line x1="175" y1="198" x2="300" y2="228" stroke={statusLine(dbStatus)} stroke-width="1.5" />

					<!-- Worker → Postgres -->
					<line x1="505" y1="198" x2="380" y2="228" stroke={statusLine(dbStatus)} stroke-width="1.5" />

					<!-- ── Dashboard node (static — no health poll) ── -->
					<rect x="260" y="14" width="160" height="38" rx="6" fill="#1f2937" stroke="#4b5563" stroke-width="1.5" />
					<text x="340" y="30" text-anchor="middle" fill="#9ca3af" font-size="11" font-family="monospace">dashboard</text>
					<text x="340" y="44" text-anchor="middle" fill="#6b7280" font-size="9" font-family="monospace">nginx :3000</text>

					<!-- ── API Gateway node ── -->
					<rect x="260" y="108" width="160" height="38" rx="6" fill={nodeFill('api-gateway')} stroke={nodeStroke('api-gateway')} stroke-width="1.5" />
					<circle cx="275" cy="127" r="4" fill={nodeStroke('api-gateway')} />
					<text x="295" y="123" fill="#e5e7eb" font-size="11" font-family="monospace">api-gateway</text>
					<text x="295" y="137" fill="#9ca3af" font-size="9" font-family="monospace">
						{services.find(s => s.name === 'api-gateway')?.version ?? ':8080'}
					</text>

					<!-- ── Catalog node ── -->
					<rect x="95" y="168" width="160" height="38" rx="6" fill={nodeFill('catalog')} stroke={nodeStroke('catalog')} stroke-width="1.5" />
					<circle cx="110" cy="187" r="4" fill={nodeStroke('catalog')} />
					<text x="130" y="183" fill="#e5e7eb" font-size="11" font-family="monospace">catalog</text>
					<text x="130" y="197" fill="#9ca3af" font-size="9" font-family="monospace">
						{services.find(s => s.name === 'catalog')?.version ?? ':8081'}
					</text>

					<!-- ── Worker node ── -->
					<rect x="425" y="168" width="160" height="38" rx="6" fill={nodeFill('worker')} stroke={nodeStroke('worker')} stroke-width="1.5" />
					<circle cx="440" cy="187" r="4" fill={nodeStroke('worker')} />
					<text x="460" y="183" fill="#e5e7eb" font-size="11" font-family="monospace">worker</text>
					<text x="460" y="197" fill="#9ca3af" font-size="9" font-family="monospace">
						{services.find(s => s.name === 'worker')?.version ?? ':8082'}
					</text>

					<!-- ── PostgreSQL node (status via /catalog/health/ready) ── -->
					<rect x="260" y="218" width="160" height="38" rx="6" fill={statusFill(dbStatus)} stroke={statusStroke(dbStatus)} stroke-width="1.5" />
					<circle cx="275" cy="237" r="4" fill={statusStroke(dbStatus)} />
					<text x="295" y="233" fill="#e5e7eb" font-size="11" font-family="monospace">postgresql</text>
					<text x="295" y="247" fill="#9ca3af" font-size="9" font-family="monospace">:5432  storage</text>
				</svg>
			</div>
		</section>

		<!-- ── Infrastructure Health (compact) ── -->
		<section class="mb-8">
			<h2 class="mb-3 text-xs font-semibold uppercase tracking-widest text-gray-500">
				Infrastructure Health
			</h2>
			<div class="grid gap-4 sm:grid-cols-1 lg:grid-cols-3">
				{#each services as svc (svc.name)}
					<div
						class="rounded-xl border bg-gray-900 p-4 shadow-lg transition-colors {cardBorderClass(svc.status)}"
					>
						<div class="mb-2 flex items-center justify-between">
							<div class="flex items-center">
								<span class={statusDotClass(svc.status)}></span>
								<h3 class="text-sm font-semibold text-white">{svc.displayName}</h3>
							</div>
							<span class="text-xs text-gray-500">:{svc.port}</span>
						</div>

						{#if svc.status === 'degraded' || svc.status === 'error'}
							<div class="mb-2 rounded bg-amber-900/30 px-2 py-1 text-xs text-amber-300">
								Unreachable — showing last known state
							</div>
						{/if}

						<div class="space-y-1 text-xs">
							<div class="flex justify-between">
								<span class="text-gray-500">version</span>
								<span class="font-mono text-gray-300">{svc.version ?? '--'}</span>
							</div>
							<div class="flex justify-between">
								<span class="text-gray-500">git sha</span>
								<span class="font-mono text-gray-400">{truncateSha(svc.gitSha)}</span>
							</div>
							<div class="flex justify-between">
								<span class="text-gray-500">latency</span>
								<span class="font-mono text-gray-300">{svc.latencyMs != null ? `${svc.latencyMs}ms` : '--'}</span>
							</div>
							<div class="flex justify-between">
								<span class="text-gray-500">checked</span>
								<span class="font-mono text-gray-400">{formatTime(svc.lastChecked)}</span>
							</div>
						</div>

						<!-- api-gateway downstream dependency status -->
						{#if svc.name === 'api-gateway' && svc.details != null}
							<div class="mt-3 border-t border-gray-700 pt-2">
								<p class="mb-1.5 text-xs text-gray-600 uppercase tracking-wider">Downstream</p>
								<div class="flex gap-2">
									<span
										class="flex items-center gap-1 rounded px-1.5 py-0.5 text-xs {svc.details.catalog
											? 'bg-green-900/40 text-green-300'
											: 'bg-amber-900/40 text-amber-300'}"
									>
										<span
											class="status-dot {svc.details.catalog
												? 'status-dot-healthy'
												: 'status-dot-degraded'}"
											style="width:5px;height:5px"
										></span>
										catalog
									</span>
									<span
										class="flex items-center gap-1 rounded px-1.5 py-0.5 text-xs {svc.details.worker
											? 'bg-green-900/40 text-green-300'
											: 'bg-amber-900/40 text-amber-300'}"
									>
										<span
											class="status-dot {svc.details.worker
												? 'status-dot-healthy'
												: 'status-dot-degraded'}"
											style="width:5px;height:5px"
										></span>
										worker
									</span>
								</div>
							</div>
						{/if}
					</div>
				{/each}
			</div>
		</section>

		<!-- ── Service Registry + Event Log ── -->
		<div class="grid gap-6 lg:grid-cols-2">

			<!-- Service Registry -->
			<section>
				<div class="mb-3 flex items-baseline justify-between">
					<h2 class="text-xs font-semibold uppercase tracking-widest text-gray-500">
						Application Catalog
						{#if catalogItems.length > 0}
							<span class="ml-1 rounded bg-gray-800 px-1.5 py-0.5 font-mono text-gray-500 normal-case">{catalogItems.length}</span>
						{/if}
					</h2>
					<span class="text-xs text-gray-600">services registered on this platform</span>
				</div>
				<div class="rounded-xl border border-gray-800 bg-gray-900">
					{#if catalogItems.length === 0}
						<!-- Skeleton while loading -->
						{#each [1, 2, 3, 4] as _}
							<div class="flex items-center justify-between border-b border-gray-800 px-4 py-3 last:border-0">
								<div class="space-y-1.5">
									<div class="h-3 w-32 animate-pulse rounded bg-gray-800"></div>
									<div class="h-2.5 w-48 animate-pulse rounded bg-gray-800"></div>
								</div>
								<div class="h-5 w-16 animate-pulse rounded bg-gray-800"></div>
							</div>
						{/each}
					{:else}
						{#each catalogItems as item (item.id)}
							<div class="flex items-start justify-between border-b border-gray-800 px-4 py-3 last:border-0 hover:bg-gray-800/40 transition-colors">
								<div class="min-w-0 flex-1 pr-3">
									<p class="text-sm font-medium text-gray-200 font-mono">{item.name}</p>
									{#if item.description}
										<p class="mt-0.5 text-xs text-gray-500 leading-relaxed">{item.description}</p>
									{/if}
								</div>
								<span class="shrink-0 rounded px-2 py-0.5 text-xs font-medium {itemStatusClass(item.status)}">
									{item.status}
								</span>
							</div>
						{/each}
					{/if}
				</div>
			</section>

			<!-- Event Log -->
			<section>
				<div class="mb-3 flex items-baseline justify-between">
					<h2 class="text-xs font-semibold uppercase tracking-widest text-gray-500">
						Event Log
						{#if recentEvents.length > 0}
							<span class="ml-1 rounded bg-gray-800 px-1.5 py-0.5 font-mono text-gray-500 normal-case">{recentEvents.length}</span>
						{/if}
					</h2>
					<span class="text-xs text-gray-600">written by worker service · 60s heartbeat</span>
				</div>
				<div class="rounded-xl border border-gray-800 bg-gray-900" style="max-height: 420px; overflow-y: auto;">
					{#if recentEvents.length === 0}
						<!-- Skeleton while loading -->
						{#each [1, 2, 3, 4] as _}
							<div class="flex items-center gap-3 border-b border-gray-800 px-4 py-3 last:border-0">
								<div class="h-5 w-20 animate-pulse rounded bg-gray-800"></div>
								<div class="flex-1 space-y-1.5">
									<div class="h-3 w-28 animate-pulse rounded bg-gray-800"></div>
									<div class="h-2.5 w-40 animate-pulse rounded bg-gray-800"></div>
								</div>
							</div>
						{/each}
					{:else}
						{#each recentEvents as evt (evt.id)}
							<div class="flex items-start gap-3 border-b border-gray-800 px-4 py-3 last:border-0 hover:bg-gray-800/40 transition-colors">
								<span class="mt-0.5 shrink-0 rounded px-2 py-0.5 text-xs font-mono {eventBadgeClass(evt.event_type)}">
									{evt.event_type}
								</span>
								<div class="min-w-0 flex-1">
									<div class="flex items-center gap-2">
										<span class="text-xs font-medium text-gray-300">{evt.source}</span>
										<span class="text-xs text-gray-600">{timeAgo(evt.created_at)}</span>
									</div>
									{#if payloadSummary(evt.payload)}
										<p class="mt-0.5 truncate text-xs text-gray-500">{payloadSummary(evt.payload)}</p>
									{/if}
								</div>
							</div>
						{/each}
					{/if}
				</div>
			</section>
		</div>

		<!-- Footer note -->
		<p class="mt-8 text-center text-xs text-gray-600">
			Polls every 30s &middot; 3s timeout per service &middot; degraded = service unreachable (not a crash)
		</p>
	</main>
</div>
