# Iceland application workspace

A native macOS UI demo, entered by choosing Iceland from the Europe country list. The map's current-application drawer also opens the workspace directly. All AI checks, community comments, reservations and processing records are local samples. No visa, booking or AI service is connected.

## Demo path

1. Iceland introduction → Start Application → three-step prefilled sheet → Overview.
2. Documents → Accommodation → Check sample booking. A generated fictional PDF appears in PDFKit; selecting a check locates its corresponding text. Local PDF import is supported, with actual-file checks left for manual review.
3. Itinerary → edit activities / drag to reorder → apply winter advice → check the sample flight change → synchronize references → preview / export PDF.
4. Share for Review → preview the public version → publish locally → accept, dismiss or reply to preset per-day suggestions. Public drafts exclude names, identifiers and raw booking files.
5. Submission → save appointment and actual submission → Tracking → contribute an anonymous date record. Charts and case counts read the same local data.
6. Result → save the result → prepare and edit an experience post → publish into the existing Discovery feed.

The workspace uses a permanently expanded native glass drawer for local navigation, grouped Form, List, Table, PDFKit, file/save panels and Swift Charts. No custom page header or segmented workspace navigation remains. Global navigation and other app pages are preserved. Parents have overview and basic material states; the detailed document demo belongs to the adult student.

## User-provided itinerary

`Itinerary.original.xlsx` is an unmodified copy of the workbook supplied by the user. `import_itinerary.py` reads its rows and creates `VisaDone/Resources/Iceland/itinerary.json`, translating display copy and retaining the supplied route, flights, accommodation and activity order. All February itinerary dates are shifted to March 2027. Airport check-in and the overnight return are retained: March 1–13 overall, March 2–12 within Schengen. The original workbook is not bundled with the app; only the structured local sample is included.

## Official reference links

- https://island.is/en/get-a-visa
- https://island.is/en/get-a-visa/where-to-apply-schengen
- https://visa.vfsglobal.com/chn/en/isl/
- https://www.vfsglobal.com/one-pager/iceland/china/english/pdf/Individual-Tourism-checklist-EN.pdf

The PDF is the current tourism-checklist link found on VFS's Iceland/China information page on October 29, 2026. No publication date is invented. Official requirements, conditional case material and community suggestions remain separate. Official passages are displayed directly from the original bilingual PDF, without rewriting or abridging them. PDFKit reads the complete relevant sections into native selectable text, with the full original source available in a native PDF reader. The original PDF is retrieved from VFS and is not bundled. Community processing times are synthetic (62 initial records, median 16 days, 80th percentile 25 days), not actual visa statistics.

Existing licensed scenery, profile pictures and flag-icons assets are reused. Native API references: Apple's Landmarks Liquid Glass sample, Swift Charts and PDFKit documentation. No sample application source code was copied.

## Native redesign and kill-ai-slop pass

After the initial implementation, the workspace was rebuilt around the actual macOS navigation and form containers. Local module navigation lives in a permanent glass drawer; assistance appears alongside its related material, without a sidebar or inspector. The original large page headings, six-way segmented chrome, marketing introduction and hand-composed dashboard rows were removed. Main forms use semantic typography and system group spacing. The existing global four-tab toolbar is preserved.

The kill-ai-slop scanner does not recognize Swift source files, so its zero scanned files is not treated as a visual pass. Manual review covered page chrome, repeated copy, custom container backgrounds and sizing. Native grouped-form surfaces, system Liquid Glass controls, source-linked official requirements, country flags and original scenery are intentional and retained.

## Content density and provenance

Materials retain the full bilingual official passages, followed by substantive, expanded community-derived preparation notes. Source gutters and SF Symbols identify official and AI-organized community information while body text uses system primary color. Each AI passage opens a native popover with the full related local post bodies and links into the existing post-detail UI. Accepting an annotation or adding a suggested material preserves its community origin. The drawer has no collapse control or drag gesture.

## Itinerary collaboration workspace

The itinerary module has two permanent modes: a daily editor alongside an AI conversation, and a complete English/bilingual itinerary document. The conversation keeps local history, targets the selected day / an explicit date range / the whole trip, and presents reversible before-and-after proposals. The supplied first conversation demonstrates a slower Snæfellsnes day with parents; no proposal changes the itinerary until accepted. Later overlapping changes retire older undo controls. Responses are deterministic local examples, with links to the existing community posts. No model service is called.

All 13 days include curated English titles, routes, transport, activities and notes. The native complete-document view retains exact dates, flight numbers and hotel names. Only PNR and confirmation codes are redacted. Language and inclusive date-range selections also control PDF export; Core Text paginates the complete document without a fixed line limit. Moving the departure date shifts the sequence and embedded Chinese date references. Community sharing uses the same full bilingual/English content and redaction rules.

## Destination introduction and applicant form

Before creation, the permanent drawer describes Iceland, Schengen membership, the main-destination rule and the member countries, with official government and VFS source links. It contains no inferred applicant identity, personal travel dates, funding arrangement or application progress. Category and submission city use native menu Pickers. A single grouped-form sheet provides adult applicant name, passport names/number, birth date, nationality, residence, contact, dates, occupation, travel party and funding inputs. The default is an employed, self-funded adult; the original student/parent scenario is no longer forced. Editing an existing application saves information without resetting its itinerary.

## Material reading layout

Each material is a native grouped-form section, with a title/status header and separate official / AI source rows. A fixed 112-point provenance gutter, 20-point column gap, reading-width constraint, paragraph spacing and numbered AI notes establish hierarchy without coloring long body text. PDF hard line wraps are reflowed while retaining every sentence and language block. Original source viewing, status filters, material navigation, source popovers and accepting suggestions keep their existing behavior.

The active AI row uses a scoped Apple Intelligence-style sweep adapted from [Livsy90/IntelligenceGlow](https://github.com/Livsy90/IntelligenceGlow), Copyright (c) 2025 Artem, MIT. The complete license is in `Licenses/IntelligenceGlow-MIT.txt`. The SwiftUI animation runs only while hovered or showing its source popover, respects Reduce Motion, and is not presented as a system Apple Intelligence service or a Liquid Glass material.
