// SPA mode: disable SSR and prerender for static nginx deployment
// The dashboard is served as a static SPA by nginx in Kubernetes
export const prerender = true;
export const ssr = false;
