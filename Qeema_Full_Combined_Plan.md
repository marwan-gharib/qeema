# Qeema (قيمة) — Complete Project Plan (Portfolio / CV Edition)

---

## Part 1 — The Project Idea, Explained in Full

Qeema is a personal finance mobile application built for the Egyptian market that answers a question most savings apps never actually ask: **not "how much money do you have," but "how much is that money actually worth."**

The starting observation behind the app is simple but easy to overlook in everyday life. Someone who has 100,000 EGP sitting in cash today will, a year from now, still see the number "100,000" if they open their bank app or count their notes. Nothing about that number changes on its own. But if inflation over that year runs at, say, 25–30%, the actual purchasing power of that money — what it can buy, how much gold it could have bought, how many months of rent it covers — has quietly shrunk, even though the number on the screen never moved. Most people feel this erosion vaguely, as a sense that "things are more expensive now," but they rarely see it quantified against their own specific savings. Qeema exists to close that gap: to take a user's real holdings and show them, concretely and visually, the difference between the *nominal* value of their money (the number) and the *real* value of their money (what that number can still buy).

The app works by letting a user log the assets they actually hold — cash in Egyptian pounds, US dollars, and gold (in the karats commonly traded locally, 21k and 24k) — along with when they acquired each amount and at what price. From that point on, Qeema continuously compares two things for the user: the nominal total of their holdings, and the same holdings adjusted for both currency movement and inflation since the day they were acquired. The result is a dashboard and a set of charts that make an otherwise abstract economic concept — inflation — into something a specific person can see happening to their specific money, in their specific currency, on their specific timeline.

Importantly, Qeema is deliberately **not** a payment app, a trading platform, or a money-transfer tool. It never moves real money, never connects to a bank account or card, and never executes any transaction. Every asset a user "adds" to the app is simply a manually entered record — a declaration of "I have this much of this thing, acquired on this date, at this price" — that the app then tracks and analyzes over time. This scope is deliberate: it keeps the app squarely in the territory of **financial data handling, calculation, and insight**, which is exactly the skill set the app is meant to demonstrate, without taking on the very different (and much heavier) regulatory, security, and liability burden that comes with actually moving money.

Beyond simple tracking, the app tries to go a step further and act as a lightweight financial advisor of sorts — not by predicting the market, but by surfacing observations a careful person would eventually notice themselves if they sat down with a spreadsheet and did the math. Things like: "your gold holdings preserved their value better than your cash holdings over the last six months," or "at the current pace of inflation, this savings goal you set will need to be revised upward to still mean what you intended it to mean." These aren't generic tips pulled from a template; they're computed from the user's own data, which is what makes them feel personally relevant rather than like boilerplate financial-wellness copy.

The app is built with Flutter for the mobile client and Supabase as the entire backend (authentication, database, and serverless functions), with no custom server of its own. This backend choice is itself part of the story the project tells: it shows that a genuinely production-shaped architecture — proper access control at the database level, structured financial calculations, offline-aware data handling — doesn't require standing up and maintaining a traditional server if the problem is scoped correctly.

Finally, and importantly for how this document should be read: **this specific build of Qeema is scoped as a portfolio and CV project, not a production application.** There are no real users, no live deployment serving the public, and no operational commitments around uptime or scale. Every design and engineering decision in this document is made with that context in mind — the architecture is built to be genuinely correct and defensible in a technical interview, while the operational scaffolding around it (server-side notification pipelines, automated data ingestion, multi-device sync robustness) is intentionally kept lean, because building that scaffolding out fully would spend time on infrastructure no one will ever exercise, instead of on the parts of the app that actually get read, tested, and discussed.

---

## Part 2 — Design System

### 2.1 Visual Direction
The app should feel warm, optimistic, and a little bold — not like a sterile banking app. The goal is a palette that makes checking your savings feel encouraging rather than anxiety-inducing, using warm golds/ambers (which also echo the app's actual subject matter — gold as an asset) paired with fresh greens that read as "growth" and "positive movement." Both palettes below are designed to be comfortable for extended viewing (no pure saturated colors used as large fill areas — everything is toned down slightly from its "loudest" version).

### 2.2 Light Theme

| Role | Color | Hex | Notes |
|---|---|---|---|
| Primary | Warm Amber | `#F5A623` | Buttons, active tab, key CTAs |
| Primary Variant | Deep Marigold | `#E08E0B` | Pressed states, headers |
| Secondary | Lemon-Lime | `#A8CD3A` | Secondary actions, highlights |
| Secondary Variant | Fresh Green | `#6FBF73` | Positive values, gains, success states |
| Background | Warm Off-White | `#FFFBF2` | Screen background |
| Surface | White | `#FFFFFF` | Cards, sheets |
| Surface Alt | Soft Cream | `#FFF3D9` | Highlighted cards (e.g. insight cards) |
| Text Primary | Charcoal | `#2B2A26` | Main text |
| Text Secondary | Warm Gray | `#79766D` | Captions, labels |
| Error / Loss | Muted Terracotta | `#D96C4B` | Losses, destructive actions — intentionally not a harsh pure red, stays within the warm palette |
| Divider | Pale Sand | `#EFE7D6` | Borders, separators |

### 2.3 Dark Theme

| Role | Color | Hex | Notes |
|---|---|---|---|
| Primary | Soft Gold | `#F0B84D` | Buttons, active tab, key CTAs |
| Primary Variant | Bright Amber | `#FFC96B` | Pressed states, emphasis |
| Secondary | Muted Lime | `#B5D66B` | Secondary actions, highlights |
| Secondary Variant | Deep Green | `#7FCB83` | Positive values, gains |
| Background | Warm Near-Black | `#17160F` | Screen background — warm-tinted, not pure black |
| Surface | Elevated Charcoal | `#221F17` | Cards, sheets |
| Surface Alt | Deep Amber Tint | `#2E2717` | Highlighted cards (e.g. insight cards) |
| Text Primary | Warm Off-White | `#F5F0E3` | Main text |
| Text Secondary | Muted Sand | `#A69E8C` | Captions, labels |
| Error / Loss | Soft Terracotta | `#E38468` | Losses, destructive actions |
| Divider | Dark Sand | `#3A3527` | Borders, separators |

### 2.4 Usage Rules
- Gains/positive movement always use the Fresh Green / Deep Green role — never a generic system green, to stay within the app's palette.
- Losses use the Terracotta role, not a harsh red — keeps the emotional tone calm rather than alarming, appropriate for a wellbeing-adjacent finance app.
- Amber/Gold is reserved for primary actions and anything representing "value" (charts, key numbers) — it should feel like the app's signature color.
- Charts (nominal vs. real value) use Amber for the nominal line and Green for the real value line, so the "gap" between them (the inflation loss) is visually a warm-to-cool contrast that's easy to read at a glance.
- Typography: a rounded, friendly sans-serif (e.g. Inter or Poppins) rather than a sharp, cold financial-terminal typeface — reinforces the "approachable" feel over "intimidating spreadsheet" feel.

---

## Part 3 — Screens, In Full Detail

For each screen: **Purpose**, **Contents**, and **Design notes** specific to that screen.

### 3.1 Splash Screen
- **Purpose:** brief branded loading moment while the app initializes (session check, theme load).
- **Contents:** centered app logo/wordmark, subtle loading indicator.
- **Design:** full-bleed background in the Primary Variant/Deep Marigold (light) or Background (dark) with the logo in the contrasting accent color — this is the one screen allowed to be a bold, near-solid color block, setting the tone immediately.

### 3.2 Welcome / Intro (2–3 pages, swipeable)
- **Purpose:** explain the core "nominal vs. real value" concept before the user commits to signing up.
- **Contents:** each page = one illustration/icon + a short headline + one supporting sentence; page indicators (dots) at the bottom; "Skip" and "Next/Get Started" actions.
- **Design:** Background color, large friendly illustrations using the accent palette (amber coin/gold bar motif, a green upward trend line motif), progress dots in Primary color.

### 3.3 Login Screen
- **Contents:** email field, password field (with show/hide toggle), "Forgot password?" link, primary "Log In" button, secondary "Don't have an account? Sign up" link.
- **Design:** Surface-colored card on Background; primary button in Amber; input fields with a soft rounded border in Divider color that shifts to Primary color on focus.

### 3.4 Sign Up Screen
- **Contents:** display name, email, password, confirm password, primary "Create Account" button, link back to Login.
- **Design:** same input styling as Login for consistency; a password-strength indicator bar using the Error→Secondary Variant gradient (terracotta to green) as the user types a stronger password.

### 3.5 Password Recovery Screen
- **Contents:** single email field, "Send Reset Link" button, confirmation state after submission ("check your inbox" message with an envelope illustration).

### 3.6 Biometric Lock Setup
- **Contents:** fingerprint/face icon illustration, short explanation of why enabling it matters, primary "Enable" button, secondary "Skip for now" text link.
- **Design:** centered, generous whitespace, icon in Primary color inside a soft circular Surface-Alt background.

---

### 3.7 Home / Dashboard
- **Purpose:** single-glance overview of the user's entire financial position.
- **Contents:**
  - Top summary card (Surface-Alt background): "Total Savings" with two large numbers stacked or side-by-side — Nominal Value (Amber, larger/bolder) and Real Value (Green, slightly smaller, labeled "adjusted for inflation").
  - A circular or bar-style indicator directly beneath showing "X% of your money's value has eroded since you started" — visually a partially-filled ring in Terracotta against a Divider-colored track.
  - Horizontally scrollable row of asset-type mini-cards (EGP / USD / Gold 21 / Gold 24), each showing current value and a tiny up/down arrow in Green/Terracotta.
  - A compact line chart (last 30 days) showing the real-value trend, in Green.
  - A floating action button (Amber, circular, "+") pinned bottom-right for quickly adding an asset.
  - If a significant price move happened today, a dismissible banner near the top in Surface-Alt with an Amber accent bar.
- **Design:** this is the "hero" screen — most generous use of the Amber/Green contrast, rounded card corners (16px), soft drop shadows in light mode / soft glow in dark mode.

---

### 3.8 My Assets (List)
- **Purpose:** browse and manage everything the user has logged.
- **Contents:**
  - Segmented tab bar at top: All / EGP Cash / USD / Gold 21 / Gold 24 (active tab underlined/filled in Amber).
  - Sort/filter icon button opening a bottom sheet (by date, by value, by type).
  - List of asset rows, each showing: asset-type icon, amount, current value, gain/loss badge (small pill, Green background for gain, Terracotta for loss), entry date in muted Text Secondary.
  - Empty state if a filtered tab has nothing yet.
- **Design:** rows use Surface color on Background, with a thin Divider line between rows rather than heavy card borders, to keep a long list feeling light rather than cluttered.

### 3.9 Add Asset
- **Contents:**
  - Visual asset-type picker: four large tappable tiles (EGP Cash / USD / Gold 21 / Gold 24), each with a distinct icon, selected tile highlighted with an Amber border and filled background tint.
  - Amount input (numeric keypad).
  - "Price at entry" field, pre-filled from the latest cached market price with a small "auto-filled — tap to edit" hint, editable.
  - Entry date picker (defaults to today).
  - Optional note field (free text).
  - Primary "Add Asset" button, fixed at the bottom.
- **Design:** generous spacing between fields so the form doesn't feel dense; the selected asset-type tile's color subtly tints the rest of the form's accent (e.g. selecting Gold 21 tints the "Add Asset" button toward a warmer gold-amber, selecting USD keeps it default Amber) — a small detail that makes the form feel responsive and alive.

### 3.10 Asset Detail
- **Contents:**
  - Header with asset-type icon, amount, and current value.
  - Gain/loss figure prominently displayed (Green or Terracotta, large font).
  - Line chart of this specific asset's value since entry date.
  - "Edit history" expandable list (from the audit trail) — each entry shows what changed and when, in a compact timeline style.
  - "Edit" (Amber outline button) and "Delete" (Terracotta outline button) actions at the bottom.
- **Design:** the chart is the visual centerpiece — full-width, Green line with a soft gradient fill beneath it fading to transparent.

### 3.11 Edit Asset
- **Contents:** identical layout to Add Asset, pre-filled with current values, button label changes to "Save Changes."

---

### 3.12 Inflation & Insights
- **Purpose:** the app's core differentiator — make inflation's effect visible and specific to the user.
- **Contents:**
  - Range selector chips at top: 1M / 3M / 1Y / All (selected chip filled Amber).
  - Large dual-line chart: Amber line = nominal value, Green line = real value, with the gap between them subtly shaded to visualize "the loss" directly.
  - "Purchasing power remaining" card — a big percentage number with a short explanatory line beneath it.
  - Horizontal bar comparison of asset-type performance (e.g. Gold 21 vs. Cash vs. USD), bars colored by relative performance (best = Green, worst = Terracotta, middle = Amber).
  - A vertically scrollable list of **Insight Cards** generated by the Financial Insight Engine — each card has a small icon (matching the insight type: inflation loss, asset performance, concentration risk, goal feasibility), a one-line headline, and a short supporting sentence. Cards use Surface-Alt background with a colored left accent bar indicating severity (Amber = informational, Terracotta = attention-worthy).
  - A collapsible "Monthly Inflation Data" table at the bottom for transparency on the numbers used.
- **Design:** this screen is allowed to feel the most "data-dense" of the app, but insight cards keep it human — mixing a chart-heavy top half with a conversational, card-based bottom half.

---

### 3.13 Savings Goals (List)
- **Contents:** each goal as a card — name, target amount, circular or linear progress indicator (Green fill), target date, small "at current inflation, this target may need to grow" hint icon if relevant.
- **Design:** cards on Surface background, progress ring in Green with the track in Divider color.

### 3.14 Add Goal
- **Contents:** goal name (free text), target amount, target asset-type picker (same tile style as Add Asset), target date picker, primary "Create Goal" button.

### 3.15 Goal Detail
- **Contents:** large progress visualization, breakdown of current contribution vs. target, the "inflation-adjusted target" callout card explained in plain language (Surface-Alt background, Amber accent), edit/delete actions.

---

### 3.16 Market Prices
- **Contents:**
  - Two summary cards: USD (buy/sell) and Gold (21k/24k), each with today's price, a small sparkline (last 7 days), and a % change badge (Green/Terracotta).
  - "Last updated" timestamp, subtle and muted.
  - Tapping a card expands into a fuller chart view (1W/1M/3M range chips).
- **Design:** the sparklines are a nice place for a restrained, single-color Amber or Green line with no axis labels — glanceable rather than analytical.

---

### 3.17 Notification Center
- **Contents:** chronological list split into "New" and "Earlier" sections, each notification row with an icon (price alert / reminder / summary), a one-line message, and a relative timestamp ("2h ago").
- **Design:** unread notifications have a small Amber dot indicator; read ones are shown at slightly reduced text opacity.

### 3.18 Notification Settings (part of Settings, or its own sub-screen)
- **Contents:** toggle switches for "USD price alerts," "Gold price alerts," "Monthly summary" — each with a one-line description beneath it.
- **Design:** toggle switches use Amber for the "on" state.

---

### 3.19 Profile
- **Contents:** avatar/initial circle, display name, email, "Edit Profile" button, "Sign Out" (Terracotta text button, since it's a semi-destructive action).

### 3.20 Settings
- **Contents, grouped into sections with subtle section headers:**
  - **Security:** biometric lock toggle, change password.
  - **Preferences:** language switch (AR/EN segmented control), default display currency.
  - **Notifications:** link into Notification Settings.
  - **About:** app version, short note on data sources.
  - **Danger Zone:** "Delete Account" in Terracotta, with a confirmation dialog that requires typing "DELETE" to proceed.
- **Design:** grouped list style (like iOS Settings), Surface-colored rows on Background, section headers in muted Text Secondary, uppercase, small.

---

### 3.21 No Internet
- **Contents:** friendly illustration (e.g. a disconnected cloud/plug), "You're offline" headline, short explanation that cached data is still shown where available, "Retry" button.

### 3.22 Empty State (e.g. Assets list before first entry)
- **Contents:** friendly illustration (e.g. an empty jar/wallet), encouraging headline ("Let's add your first asset"), short supporting line, primary "Add Asset" button.

### 3.23 General Error State
- **Contents:** simple, non-technical message ("Something went wrong on our end"), "Try Again" button, optional small "Report issue" link.

---

## Screen Count Summary

| Section | Screens |
|---|---|
| Onboarding & Auth | 6 |
| Home | 1 |
| Assets | 4 |
| Inflation & Insights | 1 |
| Savings Goals | 3 |
| Market Prices | 1 |
| Notifications | 2 |
| Profile & Settings | 2 |
| Supporting states | 3 |
| **Total** | **~23 screens** |

---

## Part 4 — External APIs (Free, With Alternatives)

All three external data needs are handled through Supabase Edge Functions, which fetch from these providers and cache the results in the database (`market_prices`, `inflation_rates`) — the Flutter app itself never calls these APIs directly, it only reads from Supabase. This keeps API keys server-side and means a provider outage or a change of provider never requires an app update.

### 4.1 USD → EGP Exchange Rate

**Primary — ExchangeRate-API Open Access (free, no key, no signup):**
```
GET https://open.er-api.com/v6/latest/USD
```
Response includes a `rates` object with `EGP` among ~160 currencies. Updates roughly once every 24 hours. No authentication required, no request limit documented for reasonable personal use.

**Sample response (trimmed):**
```json
{
  "result": "success",
  "base_code": "USD",
  "time_last_update_utc": "...",
  "rates": { "EGP": 48.5, "EUR": 0.92, "GBP": 0.79, "...": "..." }
}
```

**Backup #1 — ExchangeRate-API Standard endpoint (free tier, requires a free API key, ~1,500 requests/month):**
```
GET https://v6.exchangerate-api.com/v6/YOUR-API-KEY/latest/USD
```
Same provider, paid-tier reliability guarantees, kept as a fallback if the open endpoint is ever throttled or deprecated.

**Backup #2 — exchangerate.host:**
```
GET https://api.exchangerate.host/latest?base=USD&symbols=EGP
```
Note: this provider has shifted parts of its service behind an `access_key` requirement over time — verify current free-tier terms before relying on it, and treat it as a secondary fallback rather than the primary source.

**What could go wrong / things to know before building:**
- These rates are the official/interbank rate, not necessarily what a local money-changer or "black market" rate would show — this is worth stating transparently in the app's "About" section so users aren't confused if it doesn't match a number they saw elsewhere.
- Free tiers can update as infrequently as once per day — fine for this app's caching model (one fetch per day into `market_prices`), but don't expect intraday precision.

---

### 4.2 Gold Price (21k / 24k, in EGP)

There is no free API that returns Egyptian local gold prices directly — all free options return the international spot price (XAU, in USD per troy ounce or per gram), which then has to be converted.

**Primary — GoldAPI.io:**
```
GET https://www.goldapi.io/api/XAU/USD
Header: x-access-token: YOUR_API_KEY
```
Convenient because it returns pre-computed per-gram prices for multiple karats directly, no manual math needed:
```json
{
  "timestamp": 1777005765,
  "metal": "XAU",
  "currency": "USD",
  "price": 4665.825,
  "price_gram_24k": 150.0098,
  "price_gram_22k": 137.5089,
  "price_gram_21k": 131.2585
}
```
Free plan is limited to a small number of requests per month (check the current published limit at signup — this changes over time) — irrelevant at this app's caching frequency of roughly one fetch per day.

**Backup #1 — MetalpriceAPI:**
```
GET https://api.metalpriceapi.com/v1/latest?api_key=YOUR_API_KEY&base=USD&currencies=XAU
```
Returns raw XAU spot price; gram/karat prices must be computed manually:
```
price_per_gram_24k = (1 / XAU_rate) / 31.1034768
price_per_gram_21k = price_per_gram_24k * (21 / 24)
```

**Backup #2 — Metals-API:**
```
GET https://metals-api.com/api/latest?access_key=YOUR_API_KEY&base=USD&symbols=XAU
```
Same manual gram/karat conversion as above.

**What could go wrong / things to know before building:**
- Free-tier request limits on all three providers are low (roughly dozens to a couple hundred requests per month) — this is a non-issue for a single-demo-user portfolio app with daily caching, but would be the first thing to hit a wall if this were ever opened to real users.
- Converting international spot gold to a "what a Cairo goldsmith would actually charge" price involves a local markup this API can't know about — same transparency note as the exchange rate: label this clearly as "based on international spot price" in the UI/About section.
- If a provider's free tier changes terms (these services adjust limits periodically), having the Edge Function abstracted behind a single `PriceProvider` interface in the backend means swapping providers is a config change, not an app-wide rewrite.

---

### 4.3 Egypt Inflation Rate (Monthly)

**No free automated API exists for this at all** — this is the one data point in the whole app that cannot be sourced from a live endpoint at zero cost. Egypt's official inflation figures are published by CAPMAS (Central Agency for Public Mobilization and Statistics) and referenced by the Central Bank of Egypt, but both publish as PDF/press-release reports, not as a queryable API.

**Approach used (deliberate, not a workaround):**
- The `inflation_rates` table is seeded manually with 6–12 months of real historical monthly figures sourced from CAPMAS/CBE press releases.
- No Edge Function or scheduled job attempts to auto-fetch this data, because there is nothing free to fetch from.
- This is documented explicitly in the project README as an intentional scope decision: "monthly inflation data is manually curated from official CAPMAS/CBE releases because no free structured API exists for this data in Egypt; the architecture (a plain monthly rate table) is designed so an automated feed could be substituted in a single Edge Function if a paid data provider were adopted later."

**If a paid option were ever needed later (for context, not part of this build):** providers like Trading Economics or CEIC offer structured macroeconomic data including inflation via paid API plans — worth knowing exists, not worth building against for a CV-scope project.

---

### 4.4 Push Notifications — Firebase Cloud Messaging (for context, not built in this scope)

FCM itself is free with no practical limit for an app this size, but as covered in the Technical Plan, the full send pipeline (Database Webhook → Edge Function → FCM) is **not implemented** in this portfolio build — only local, on-device notifications are. This section exists so the "APIs used" list is complete and honest: nothing here needs a workaround, it's simply out of scope by choice, and the reasoning is documented in the technical plan.

---

## Part 5 — Feature Summary (Portfolio / CV Scope Only)

| Feature | Included in this build |
|---|---|
| Email/password auth + biometric lock | ✅ Full |
| Add/edit/soft-delete assets (EGP, USD, Gold 21/24) | ✅ Full |
| Gain/loss calculation per asset | ✅ Full |
| Compound inflation calculation (nominal vs. real value) | ✅ Full, mathematically correct |
| Dashboard with summary + mini chart | ✅ Full |
| Inflation & Insights screen with dynamic insight cards | ✅ Full |
| Savings goals with inflation-adjusted target awareness | ✅ Full |
| Market prices screen (USD, gold) | ✅ Full |
| Audit trail / edit history per asset | ✅ Full |
| Row Level Security on all user data | ✅ Full |
| Offline cache-first reads (Drift) | ✅ Full pattern, simplified sync (no backoff queue/conflict resolution) |
| Local notifications for price alerts | ✅ Simplified — on-device only, no server push pipeline |
| Server-side push (FCM pipeline) | ❌ Documented in README, not implemented |
| Automated inflation data ingestion | ❌ Not possible free — manual monthly entry instead, documented as deliberate |
| Multi-currency base switching | ❌ Out of scope — EGP hardcoded as base currency |
| Production-grade uptime / scaling | ❌ Not applicable — free-tier Supabase, demo-only usage |
