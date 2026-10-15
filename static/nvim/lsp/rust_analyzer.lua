return {
	-- Run `cargo check` on save, not `cargo clippy` (clippy costs more).
	-- check = { command = 'check' },

	-- Use a separate target directory, so rust-analyzer's `cargo check`
	-- and your own `cargo build` do not invalidate each other's caches
	-- and wait on the same build lock. Costs disk space.
	cargo = { targetDir = true },

	-- Do not index all dependencies at startup; index them on demand.
	cachePriming = { enable = false },

	-- Limit worker threads (default: number of CPU cores).
	numThreads = 2,

	-- Skip scanning these directories. .direnv holds flake-related
	-- files from `use flake` that rust-analyzer does not need.
	files = { excludeDirs = { ".direnv" } },
}
