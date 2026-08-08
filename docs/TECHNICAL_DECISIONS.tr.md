# Teknik Kararlar

[English](TECHNICAL_DECISIONS.md) · [Türkçe](TECHNICAL_DECISIONS.tr.md)

Bu kararlar salt-okunur incelemede gözlemlenen desenlere dayanır. Mühendislik yaklaşımını açıklarken tescilli implementasyonu açığa çıkarmamak için üst seviyede tutulmuştur.

## 1. Özellik-öncelikli katman sınırları

**Problem**
Ürün özellikleri farklı hızlarda gelişirken API, kalıcılık ve UI sorumlulukları birbirine sıkı bağlanabilir.

**Mühendislik kararı**
Kapsamlı özellikleri presentation, domain ve data katmanlarına ayır. Repository sözleşmelerini domain'in sahiplenmesini, data implementasyonlarının bunları karşılamasını sağla.

**Ödün / neden**
Arayüzler ve mapping seremoniyi artırır; karşılığında özellik sahipliği ve altyapının değiştirilebilirliği netleşir. Sınır, akış karmaşıklığının haklı çıkardığı yerlerde kullanılır.

## 2. Açık Cubit/BLoC state'leri

**Problem**
Asenkron ekranlar ilk yükleme, yenileme, sonraki sayfa, boş veri, toparlanabilir hata ve korunmuş içeriği temsil etmelidir.

**Mühendislik kararı**
Açık state'lere sahip Cubit/BLoC sahipleri ve odaklı selector'lar kullan. Sayfalı yükleme aşamalarını tek boolean yerine ayrı modelle.

**Ödün / neden**
Daha fazla state tipi disiplin gerektirir; buna karşılık geçişler test edilebilir ve widget'lar yalnızca gösterdikleri veriyi izler.

## 3. Domain sınırında tipli sonuçlar

**Problem**
Transport exception'ları presentation koduna ulaşırsa her özellik ağ hatalarını bağımsız yorumlamak zorunda kalır.

**Mühendislik kararı**
İşlemleri tipli başarı/failure sonuçlarına normalize et; HTTP exception mapping'ini ortak/data altyapısında tut.

**Ödün / neden**
Mapping ek dönüştürme işi getirir, ancak UI'ı transport bağımlılığından kurtarır ve hata yollarını açık hale getirir.

## 4. Ortak API istemcisi ve özellik data source'ları

**Problem**
Özellikler istemcileri ayrı oluşturursa kimlik doğrulama, header, timeout, serialization ve hata dönüştürme tutarsızlaşır.

**Mühendislik kararı**
Ortak Dio tabanlı istemci sağla; özellik data source'ları uzak işlemlerinin ve model dönüşümlerinin sahibi olsun.

**Ödün / neden**
İstemci altyapı odaklı kalmalıdır. Karşılığında yatay transport davranışının tek sahibi olur.

## 5. Sıralı ve modüler dependency injection

**Problem**
Özellik servisleri asenkron başlatma gerektiren cache veya core servislerine bağımlı olabilir.

**Mühendislik kararı**
GetIt modüllerini tanımlı sırada kaydet — temel servisler özelliklerden önce — ve başlangıçta hazır olmayı bekle.

**Ödün / neden**
Başlatma sırası korunması gereken sözleşmeye dönüşür. Nesne üretimi deterministik, rota fabrikaları soyutlamalara bağımlı olur.

## 6. Cursor tabanlı artımlı yükleme

**Problem**
Büyük koleksiyonları tek seferde almak ilk işi artırır; yenileme, retry ve liste sonunu ayırmayı zorlaştırır.

**Mühendislik kararı**
İlk yükleme ile sonraki sayfa geçişlerini ayıran yeniden kullanılabilir cursor tabanlı paging state'i kullan.

**Ödün / neden**
Cursor ve tekrar önleme kuralları karmaşıklık ekler. UI görünür öğeleri korur ve tüm ekranı sıfırlamadan artımlı hatayı yeniden deneyebilir.

## 7. Latest-wins iptal edilebilir işlemler

**Problem**
Hızlı kullanıcı eylemleri, yanıtları farklı sırada gelen çakışan istekler başlatabilir.

**Mühendislik kararı**
Yeni niyetin eski işi geçersiz kıldığı etkileşimlerde iptal edilebilir işlem sahipliği kullan.

**Ödün / neden**
İptal yaşam döngüsü yönetilmelidir ve her işlem güvenle iptal edilemez. Uygun olduğunda eski yanıt güncel state olamaz.

## 8. Merkezi görsel davranışı

**Problem**
Görsel yoğun yüzeyler tutarlı placeholder, hata, timeout, cache ve birden fazla kaynak türüne ihtiyaç duyar.

**Mühendislik kararı**
Ürün görsellerini yerleşik image/cache paketleriyle desteklenen ortak bir soyutlama üzerinden göster.

**Ödün / neden**
Wrapper yeterli esnekliği sunmalı, alttaki paketin her seçeneğini tekrar etmemelidir. Merkezi sahiplik cache ve fallback davranışını tutarlı kılar.

## 9. Sorumluluğa göre depolama

**Problem**
Yapısal offline veri, küçük tercihler ve hassas yerel değerler farklı sorgu ve güvenlik gereksinimlerine sahiptir.

**Mühendislik kararı**
Yapısal kalıcılık için Drift, hassas değerler için secure storage, küçük ayarlar için preferences, medya/içerik için özel cache kullan.

**Ödün / neden**
Birden fazla mekanizma açık sahiplik ve migration pratiği gerektirir; her veri kategorisini uygun olmayan tek araca zorlamaz.

## 10. Özelliklerin sahip olduğu rota fabrikaları

**Problem**
Tek global router sayfa kurulum ayrıntılarını ve somut bağımlılıkları biriktirebilir.

**Mühendislik kararı**
GoRouter'ı özellik rota modülleri/fabrikalarıyla kullan; hedef oluşturulurken bağımlılıkları enjekte et.

**Ödün / neden**
Navigasyon sözleşmeleri dağılır ve isimlendirme disiplini gerektirir. Özellik sınırları net, sayfa kurulumu test edilebilir kalır.
