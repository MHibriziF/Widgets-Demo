# widget_concerns

A Flutter demo app for learning two core widget concepts side by side:

- **Widget Lifecycle** — visualises `initState`, `didChangeDependencies`, `setState`, `didUpdateWidget`, `deactivate`, and `dispose` in real time via an on-screen log panel.
- **Widget Composition** — contrasts a monolithic widget (counter state and static cards in one `build()`) against a properly sliced one (extracted `StatelessWidget`s with `const`), making the rebuild difference visible in DevTools Widget Rebuild Stats.

---

## Running

### With Makefile

Setup and run

```bash
make setup
make run
```

### With Flutter commands

```bash
flutter pub get
flutter run
dart run build_runner build --delete-conflicting-outputs
```
