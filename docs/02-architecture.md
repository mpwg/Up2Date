# Up2Date – Architektur

## Übersicht
Die Architektur ist modular aufgebaut und trennt klar zwischen Quellen (Sources), Update-Logik und UI.

## Komponenten

### 1. Core
- AppRegistry: verwaltet installierte Apps
- UpdateManager: orchestriert Update-Prozesse

### 2. Sources
Jede Quelle implementiert ein gemeinsames Protokoll:

```
protocol UpdateSource {
    func scanInstalledApps() async -> [App]
    func checkForUpdates(apps: [App]) async -> [Update]
    func performUpdate(update: Update) async throws
}
```

Implementierungen:
- AppStoreSource
- SparkleSource
- BrewSource

### 3. Update Engine
- Vereinheitlicht Update-Infos
- Priorisiert Updates
- Fehlerhandling

### 4. UI Layer (SwiftUI)
- Dashboard
- Update Liste
- Detailansicht

### 5. Background Services
- Periodischer Check
- Notifications

## Datenfluss
1. Scan installierter Apps
2. Mapping zu Quellen
3. Update Check
4. Darstellung in UI
5. Optional: Update ausführen

## Technologien
- Swift / SwiftUI
- Combine / Async Await
- Shell Integration für brew
- StoreKit / private APIs (falls möglich)

## Erweiterbarkeit
Neue Quellen können einfach durch Implementierung von UpdateSource ergänzt werden.
