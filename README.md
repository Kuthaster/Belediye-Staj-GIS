# Coğrafi Nesne Takip Sistemi

Sokaklardaki cisimlerin konum ve detay bilgisi için GPS tabanlı sistem 
Cisimler: aydınlatma direkleri, banklar, ağaçlar, park ekipmanları, çöp kutuları

Field workers register objects on-site via a mobile app; all users can browse objects as a list or on a map.
Saha görevlileri cisimleri gerçek konumunda mobil uygulama ile kaydedebiliyor ve herkes objeleri harita üstünde veyahut bir liste halinde detaylarıyla görebiliyor.

## Teknoloji Yığını


Mobil Uygulama: Flutter (dio + Riverpod)
Harita: flutter_map (OpenStreetMap)
Backend: Java SpringBoot
Veritabanı: PostgreSQ + PostGIS (Uzamsal veri için)
Nesne İlişkisel Haritalama (ORM): Hibernate Spatial + JTS
Migrasyon: Flyway

## Backend Kurulumu

1. Veritabanı oluşturup PostGIS'i etkinleştir:
   ```sql
   CREATE DATABASE urbanassets;
   \c urbanassets
   CREATE EXTENSION IF NOT EXISTS postgis;
   ```
2. `backend/cografi-nesne-takip/src/main/resources/application-example.properties` dosyasındaki değerleri `backend/cografi-nesne-takip/src/main/resources/application.properties (committe yok)` konumuna yapıştırıp yerel değerlerinizi girin (Veritabanı kullanıcı adı ve şifresi vs.)

3. Backendi çalıştırın:
   ```bash
   cd backend/cografi-nesne-takip
   ./mvnw spring-boot:run
   ```
   Flyway migrasyonları otomatik olarak halledecek. The API `http://localhost:8080` de çalışacak.

## Frontend Kurulumu

1. Dependency'leri indirin:
   ```bash
   cd frontend
   flutter pub get flutter_map
   flutter pub get dio
   flutter pub get flutter_riverpod
   flutter pub get latlong2
   flutter pub get geolocator
   ```
2. Uygulamayı çalıştır:
   ```bash
   flutter run
   ```
   Uygulama güncel haliyle `http://10.0.2.2:8080/api` adresine bağlı (Android emulatorüne `localhost`). `lib/services/api_client.dart`'tan değiştirebilirsiniz.

## Güncel Durum

Backend CRUD tamam. Frontend başlandı (API client). RBA henüz yok.