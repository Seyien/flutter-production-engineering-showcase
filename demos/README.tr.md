# Demo hazırlama

[English](README.md) · [Türkçe](README.tr.md)

Dört özellik odaklı kaynak video bu deponun dışında korunur. Eski birleşik kayıt artık planın parçası değildir. Kaynak dosyalar hiçbir zaman yerinde düzenlenmemelidir.

## İşe alım odaklı önerilen kesitler

| Klip | Kaynak kayıt | Kaynak aralığı | Süre | Odak |
| --- | --- | --- | ---: | --- |
| Ana Sayfa / Genel Bakış | Ana sayfa | `00:00–00:45` | 45 sn | Ana sayfa kompozisyonu, duyurular ve navigasyon |
| Öneriler / Geçmiş | Öneriler | `00:00–00:42.5` | 43 sn | Öneri akışı ve okuma geçmişi yönetimi |
| Arama / Seri Detayı | Arama ve detay | `00:00–00:55` | 55 sn | Arama, filtreler, detay hiyerarşisi ve ana eylemler |
| Kütüphane / Bölüm Seçimi | Arama ve detay | `01:10–01:55` | 45 sn | Bölüm seçimi, indirme eylemleri ve state geri bildirimi |
| Okuyucu Deneyimi | Okuyucu | `00:15–01:15` | 60 sn | Okuma, kontroller ve okuyucu ayarları |

Daha uzun arama/detay kaydı ayrı bir seçim ve indirme akışı da içerdiği için dört kaynak dosyadan beş odaklı portföy klibi üretilir.

## Yayın kapısı

Ham kayıtları yayımlamayın. İncelemede üçüncü taraf kapak/sayfa görselleri ve bazı sahnelerde görünür topluluk adları/yorumları bulundu. Yalnızca aşağıdaki koşulların tamamını karşılayan yeni veya düzenlenmiş dışa aktarımları yayımlayın:

1. Kişisel ad, avatar, yorum, bildirim, cihaz kimliği ve özel URL bulunmamalı veya geri döndürülemez biçimde redakte edilmelidir.
2. Görünen her kapak, sayfa, ikon, font ve ses parçası lisanslı, özgün veya yayın için açıkça onaylanmış olmalıdır.
3. Özel endpoint, operasyonel duyuru, aktivasyon akışı veya tescilli kural okunabilir olmamalıdır.
4. Dışa aktarılan her kare normal hızda ve sahne sınırlarında incelenmelidir.
5. Medya eklendikten sonra depo güvenlik taraması geçmelidir.

## Yerel klip üretimi

İnceleme yapılan bilgisayarda paketlenmiş bir FFmpeg çalıştırılabilir dosyası bulunur. Betik, `PATH` üzerindeki standart FFmpeg kurulumunu da destekler:

```powershell
.\demos\create-clips.ps1 `
  -HomeVideo "C:\path\to\sanitized-home.mp4" `
  -RecommendationsVideo "C:\path\to\sanitized-recommendations.mp4" `
  -SearchDetailVideo "C:\path\to\sanitized-search-detail.mp4" `
  -ReaderVideo "C:\path\to\sanitized-reader.mp4" `
  -CreatePreviews
```

FFmpeg `PATH` üzerinde değilse `-FfmpegPath` kullanın. Çıktılar, her biri yayın kapısından geçene kadar Git tarafından yok sayılan `demos/generated/` klasörüne yazılır. Betik hiçbir kaynak kaydın üzerine yazmaz.
