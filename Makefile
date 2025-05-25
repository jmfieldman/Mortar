bootstrap:
	@brew install mint
	@mint install nicklockwood/SwiftFormat
	@cp bin/githooks/pre-commit .git/hooks/.

format:
	@mint run swiftformat --config .swiftformat .

.PHONY: bootstrap \
	format
