import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: vitePreprocess(),
	kit: {
		adapter: adapter({
			// SPA fallback — serves index.html for all routes
			fallback: 'index.html',
			pages: 'build',
			assets: 'build',
			precompress: false,
			strict: false
		}),
		paths: {
			base: ''
		}
	}
};

export default config;
