# auth_app

Project Architecture Overview

This project follows a clean and scalable architecture with clear separation of concerns.
Key principles include networking modularization, functional error handling, local caching, and repository-driven data orchestration.

🔌 Networking Layer

DioClient is extracted into the networking/ directory to keep all network-related logic isolated and reusable.

Centralizes base configuration, interceptors, and request handling.

🧩 Functional Result Handling

Uses a Result pattern (Either) for data handling.

Ensures every API call returns either:

Success(data) or

Failure(error)

Allows clean and predictable state checking following Functional Programming practices.

💾 Local Storage & Caching

Uses shared_preferences to persist data in Local Storage.

Provides:

Lightweight caching

Faster UI rendering

Lower API usage

Ideal for storing small datasets and reducing unnecessary API calls.

🗂 Repository Layer

Repositories orchestrate and manage all data flow.

Responsibilities:

Combine local + remote data sources

Enrich or transform models when needed

Act as the single source of truth for upper layers (UI, Bloc, etc.)
