# Technical Decisions

[English](TECHNICAL_DECISIONS.md) · [Türkçe](TECHNICAL_DECISIONS.tr.md)

These decisions are grounded in patterns observed during read-only inspection. They remain high level so they explain engineering judgment without exposing proprietary implementation.

## 1. Feature-first layered boundaries

**Problem**
Product features evolve at different speeds, while API, persistence, and UI concerns can become tightly coupled.

**Engineering decision**
Organize substantial features into presentation, domain, and data layers. Let the domain own repository contracts and data-layer implementations satisfy them.

**Trade-off / reason**
Interfaces and mappings add ceremony, but feature ownership and infrastructure replacement become clearer. The boundary is used where workflow complexity justifies it.

## 2. Explicit Cubit/BLoC states

**Problem**
Asynchronous screens need to represent first load, refresh, next-page progress, empty data, recoverable error, and retained content.

**Engineering decision**
Use Cubit/BLoC owners with explicit states and focused selectors. Model paged loading phases separately rather than using one boolean.

**Trade-off / reason**
More state types require discipline, but transitions become testable and widgets can observe only what they render.

## 3. Typed results at the domain boundary

**Problem**
If transport exceptions reach presentation code, every feature must interpret networking failures independently.

**Engineering decision**
Normalize operations into typed success/failure results and keep HTTP exception mapping in shared/data infrastructure.

**Trade-off / reason**
Mapping adds translation work, but removes transport coupling from the UI and makes expected error paths explicit.

## 4. Shared API client and feature data sources

**Problem**
Authentication, headers, timeouts, serialization, and error conversion become inconsistent when features construct clients independently.

**Engineering decision**
Provide a shared Dio-based client, while feature-owned data sources retain responsibility for their remote operations and model conversion.

**Trade-off / reason**
The client must remain infrastructure-focused. In return, cross-cutting transport behavior has one owner.

## 5. Ordered modular dependency injection

**Problem**
Feature services can depend on cache or core services that require asynchronous initialization.

**Engineering decision**
Register GetIt modules in a defined sequence — foundational services before feature modules — and await readiness during startup.

**Trade-off / reason**
Initialization order becomes a contract that must be maintained. Construction is deterministic and route factories can depend on abstractions.

## 6. Cursor-based incremental loading

**Problem**
Fetching large collections at once increases initial work and makes refresh, retry, and list-end behavior harder to distinguish.

**Engineering decision**
Use reusable cursor-based paging state with separate first-load and next-page transitions.

**Trade-off / reason**
Cursor and deduplication rules add state complexity. The UI can preserve visible items and retry an incremental failure without resetting the screen.

## 7. Latest-wins cancelable operations

**Problem**
Rapid user actions can start overlapping requests whose responses arrive out of order.

**Engineering decision**
Use cancelable operation ownership where a newer intent supersedes older work.

**Trade-off / reason**
Cancellation lifecycle must be managed and not every operation is safely cancelable. Where applicable, stale responses cannot become current state.

## 8. Centralized image behavior

**Problem**
Image-heavy surfaces need consistent placeholders, failures, timeouts, caching, and multiple source types.

**Engineering decision**
Route product image rendering through a shared abstraction backed by established image/cache packages.

**Trade-off / reason**
The wrapper must expose enough flexibility without mirroring every package option. Central ownership keeps caching and fallbacks consistent and replaceable.

## 9. Storage by responsibility

**Problem**
Structured offline data, small preferences, and sensitive local values have different query and security requirements.

**Engineering decision**
Use Drift for structured persistence, secure storage for sensitive values, preferences for small settings, and dedicated caches for media/content.

**Trade-off / reason**
Multiple mechanisms require clear ownership and migration practices, but avoid forcing every data category into one unsuitable tool.

## 10. Feature-owned route factories

**Problem**
A single global router can accumulate page construction details and concrete dependencies.

**Engineering decision**
Use GoRouter with feature route modules/factories and inject dependencies as destinations are created.

**Trade-off / reason**
Navigation contracts are distributed and require naming discipline. Feature boundaries remain clearer and page construction stays testable.
