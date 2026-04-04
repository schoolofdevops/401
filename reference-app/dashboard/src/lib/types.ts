/**
 * Service status values:
 * - healthy:  service responded successfully
 * - degraded: service unreachable or returned non-2xx (shown as warning, not crash)
 * - unknown:  not yet polled (initial state)
 * - error:    unexpected error during polling (shown like degraded)
 */
export type ServiceStatus = 'healthy' | 'degraded' | 'unknown' | 'error';

/**
 * Health data for a single backend service, populated by pollServices().
 */
export interface ServiceHealth {
	name: string;
	displayName: string;
	port: number;
	status: ServiceStatus;
	version?: string;
	gitSha?: string;
	latencyMs?: number;
	lastChecked?: Date;
	/** Downstream dependency status (api-gateway only) */
	details?: {
		catalog?: boolean;
		worker?: boolean;
		database?: boolean;
	};
}

/**
 * Overall system status derived from all service health states.
 */
export type SystemStatus = 'all-healthy' | 'degraded' | 'connecting';

/**
 * Static configuration for each service we poll.
 */
export interface ServiceConfig {
	name: string;
	displayName: string;
	port: number;
	/** URL path prefix to reach this service through nginx proxy */
	pathPrefix: string;
}
