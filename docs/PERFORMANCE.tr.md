# Performans

[English](PERFORMANCE.md) · [Türkçe](PERFORMANCE.tr.md)

Bu belge özel projede gözlemlenen performans odaklı desenleri açıklar. Benchmark, gecikme, kare hızı, bellek veya ölçek iddiasında bulunmaz.

## Artımlı veri yükleme

Büyük akışlar cursor tabanlı sayfalama kullanır. İlk yükleme, sonraki sayfa, yenileme, hata ve veri sonu ayrı temsil edilir. Böylece içerik aşamalı gösterilir ve yeni veri istenirken görünür içerik gereksiz yere değiştirilmez.

## Odaklı rebuild işlemleri

Ortak BLoC selector desenleri widget'ları state'in ilgili izdüşümlerine abone eder. Amaç, geniş state değişikliklerinin ilgisiz alt ağaçları rebuild etmesini azaltmak ve sahipliği widget sınırında görünür kılmaktır.

## İptal edilebilir asenkron işlemler

Bazı etkileşimler latest-wins kuralını izler. Yeni kullanıcı niyeti eskisini geçersiz kıldığında önceki asenkron iş iptal edilebilir veya sonucu yok sayılabilir; stale-state yarışları azalır.

## Görsel ve içerik önbelleği

Merkezi görsel katmanı ağ yüklemesini bellek/disk cache davranışı, placeholder/fallback state'leri, timeout ve retry kontrolleriyle birleştirir. Görsel yoğun yüzeylerde ortak kullanılması özellik bazında farklı politikaları önler.

Cache güncellik/depolama ödünü taşır; özel politika değerleri ve saklama ayrıntıları yayımlanmaz.

## Kararlı asenkron UI

Skeleton, placeholder, empty state, artımlı ilerleme ve retry yüzeyleri tek bir global spinner yerine yapılan işi anlaşılır kılar. Arka plan indirmeleri ilerlemeyi ana etkileşimden ayrı gösterir.

## Responsive kompozisyon

Ortak araçlar genişlik, yükseklik, metin ve radius değerlerini ölçekler. Breakpoint tabanlı düzenler tanımlı viewport kategorilerinde navigasyon ve yoğunluğu değiştirerek geçici hesapları azaltır.

## Performansın güvenilirlik yönü

Tipli failure'lar ve transport soyutlaması presentation katmanında tekrar eden exception ayrıştırmasını azaltır. Bağımlılık başlangıcı sıralanır ve özelliklerden önce beklenir; kısmen başlatılmış servisler önlenir.

## Kanıt sınırı

Bu depo bilerek şu iddialarda bulunmaz:

- belirli bir kare hızı veya render yüzdelik değeri;
- ölçülmüş bellek, bant genişliği veya başlangıç süresi kazancı;
- kullanıcı, istek veya cache-hit metriği;
- alternatif bir mimariye karşı üstünlük.

Bu iddialar, showcase kapsamında bulunmayan yayımlanabilir profiling verisi gerektirir.
