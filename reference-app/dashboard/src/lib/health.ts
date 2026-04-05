/**
 * Health polling logic for the Agentic DevOps reference app dashboard.
 *
 * Design: graceful degradation — if a service is unreachable we set status
 * to 'degraded' and continue. The dashboard NEVER crashes or shows an error
 * page. Participants see the degraded state during failure injection exercises.
 *
 * Uses AbortSignal.timeout(3000) so a stalled service doesn't block the
 * entire poll cycle — critical when injecting failures during labs.
 */
import type { CatalogItem, ServiceConfig, ServiceHealth, SystemStatus, WorkerEvent } from './types.js';

/** Services to poll, in display order. */
export const SERVICE_CONFIGS: ServiceConfig[] = [
	{
		name: 'api-gateway',
		displayName: 'API Gateway',
		port: 8080,
		pathPrefix: '/api-gateway'
	},
	{
		name: 'catalog',
		displayName: 'Catalog',
		port: 8081,
		pathPrefix: '/catalog'
	},
	{
		name: 'worker',
		displayName: 'Worker',
		port: 8082,
		pathPrefix: '/worker'
	}
];

/** Initial unknown state for all services (before first poll). */
export function initialServiceStates(): ServiceHealth[] {
	return SERVICE_CONFIGS.map((cfg) => ({
		name: cfg.name,
		displayName: cfg.displayName,
		port: cfg.port,
		status: 'unknown' as const
	}));
}

/**
 * Poll all services once and return updated health data.
 *
 * @param baseUrl - base URL for the nginx proxy (e.g. '' for same-origin, or 'http://localhost:3000')
 * @param previous - previous health states (used as fallback if a service fails)
 */
export async function pollServices(
	baseUrl: string,
	previous: ServiceHealth[]
): Promise<ServiceHealth[]> {
	const results = await Promise.all(
		SERVICE_CONFIGS.map((cfg, idx) => pollOneService(cfg, baseUrl, previous[idx]))
	);
	return results;
}

async function pollOneService(
	cfg: ServiceConfig,
	baseUrl: string,
	previous: ServiceHealth
): Promise<ServiceHealth> {
	const start = Date.now();
	const versionUrl = `${baseUrl}${cfg.pathPrefix}/version`;

	try {
		const res = await fetch(versionUrl, {
			signal: AbortSignal.timeout(3000)
		});
		const latencyMs = Date.now() - start;

		if (!res.ok) {
			return {
				...previous,
				status: 'degraded',
				latencyMs,
				lastChecked: new Date()
			};
		}

		const data = await res.json();

		const health: ServiceHealth = {
			name: cfg.name,
			displayName: cfg.displayName,
			port: cfg.port,
			status: 'healthy',
			version: data.version ?? undefined,
			gitSha: data.git_sha ?? undefined,
			latencyMs,
			lastChecked: new Date()
		};

		// For api-gateway, also fetch /health/ready to get downstream dependency status
		if (cfg.name === 'api-gateway') {
			health.details = await pollApiGatewayReady(baseUrl, cfg.pathPrefix);
		}

		return health;
	} catch {
		// Timeout, network error, JSON parse failure — show degraded, not crash
		return {
			...previous,
			status: 'degraded',
			latencyMs: Date.now() - start,
			lastChecked: new Date()
		};
	}
}

async function pollApiGatewayReady(
	baseUrl: string,
	pathPrefix: string
): Promise<ServiceHealth['details']> {
	try {
		const res = await fetch(`${baseUrl}${pathPrefix}/health/ready`, {
			signal: AbortSignal.timeout(3000)
		});
		if (!res.ok) return undefined;
		const data = await res.json();
		return {
			catalog: data.catalog === true,
			worker: data.worker === true
		};
	} catch {
		return undefined;
	}
}

/**
 * Derive overall system status from per-service health states.
 */
export function deriveSystemStatus(services: ServiceHealth[]): SystemStatus {
	const allUnknown = services.every((s) => s.status === 'unknown');
	if (allUnknown) return 'connecting';

	const allHealthy = services.every((s) => s.status === 'healthy');
	if (allHealthy) return 'all-healthy';

	return 'degraded';
}

/**
 * Format a Date as a short time string (HH:MM:SS) for "last checked" display.
 */
export function formatTime(date: Date | undefined): string {
	if (!date) return '--:--:--';
	return date.toLocaleTimeString('en-US', {
		hour: '2-digit',
		minute: '2-digit',
		second: '2-digit',
		hour12: false
	});
}

/**
 * Return a human-readable relative time string ("just now", "2 minutes ago").
 */
export function timeAgo(isoString: string): string {
	const diffMs = Date.now() - new Date(isoString).getTime();
	const secs = Math.floor(diffMs / 1000);
	if (secs < 10) return 'just now';
	if (secs < 60) return `${secs}s ago`;
	const mins = Math.floor(secs / 60);
	if (mins < 60) return `${mins}m ago`;
	const hours = Math.floor(mins / 60);
	if (hours < 24) return `${hours}h ago`;
	return `${Math.floor(hours / 24)}d ago`;
}

/**
 * Fetch the service registry from the catalog.
 * Returns empty array on any error — never throws.
 */
export async function fetchCatalogItems(): Promise<CatalogItem[]> {
	try {
		const res = await fetch('/catalog/items', { signal: AbortSignal.timeout(5000) });
		if (!res.ok) return [];
		const data = await res.json();
		return Array.isArray(data.items) ? data.items : [];
	} catch {
		return [];
	}
}

/**
 * Fetch the 50 most recent operational events from the worker.
 * Returns empty array on any error — never throws.
 */
export async function fetchRecentEvents(): Promise<WorkerEvent[]> {
	try {
		const res = await fetch('/worker/events/recent', { signal: AbortSignal.timeout(5000) });
		if (!res.ok) return [];
		const data = await res.json();
		return Array.isArray(data.events) ? data.events : [];
	} catch {
		return [];
	}
}
