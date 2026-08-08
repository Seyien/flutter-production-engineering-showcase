# Demo preparation

[English](README.md) · [Türkçe](README.tr.md)

Four purpose-recorded source videos are preserved outside this repository. The older combined recording is not part of the plan. Source files must never be edited in place.

## Proposed recruiter-friendly cuts

| Clip | Source recording | Source range | Duration | Focus |
| --- | --- | --- | ---: | --- |
| Home / Overview | Home | `00:00–00:45` | 45 sec | Home composition, announcements, and navigation |
| Recommendations / History | Recommendations | `00:00–00:42.5` | 43 sec | Suggestion workflow and reading-history management |
| Search / Series Detail | Search and detail | `00:00–00:55` | 55 sec | Search, filters, detail hierarchy, and primary actions |
| Library / Chapter Selection | Search and detail | `01:10–01:55` | 45 sec | Chapter selection, download actions, and state feedback |
| Reader Experience | Reader | `00:15–01:15` | 60 sec | Reading, controls, and reader settings |

The four source files produce five focused portfolio clips because the longer search/detail recording also contains a distinct selection and download flow.

## Publication gate

Do not publish the raw recordings. Review found third-party cover/page artwork and, in some scenes, visible community names/comments. Publish only replacements or edited exports for which all of the following are true:

1. Personal names, avatars, comments, notifications, device identifiers, and private URLs are absent or irreversibly redacted.
2. Every visible cover, page, icon, font, and audio track is licensed, original, or explicitly approved for publication.
3. No private endpoint, operational announcement, activation flow, or proprietary rule is readable.
4. Every exported frame has been reviewed at normal speed and at scene boundaries.
5. The repository security scan passes after the media is added.

## Local clip generation

A bundled FFmpeg executable is available on the inspection host. The script also supports a regular FFmpeg installation via `PATH`:

```powershell
.\demos\create-clips.ps1 `
  -HomeVideo "C:\path\to\sanitized-home.mp4" `
  -RecommendationsVideo "C:\path\to\sanitized-recommendations.mp4" `
  -SearchDetailVideo "C:\path\to\sanitized-search-detail.mp4" `
  -ReaderVideo "C:\path\to\sanitized-reader.mp4" `
  -CreatePreviews
```

Use `-FfmpegPath` if FFmpeg is not on `PATH`. Outputs are written to `demos/generated/`, which is ignored by Git until each file passes the publication gate. The script never overwrites any source recording.
