# Gemini Illustration Briefs — Module 05

> Generate these illustrations using Google Gemini's image generation.
> Style: Black & white, hand-drawn sketch style, clean lines, whiteboard aesthetic.
> No colors. No gradients. Just black ink on white background.

---

## Illustration 3: Reading the Email Before Replying

**Prompt for Gemini:**

```
Create a black and white hand-drawn sketch illustration, whiteboard style, clean lines, no colors:

Split scene with a dividing line down the middle.

LEFT SIDE - labeled "Prefill: Reading the entire email":
A stick figure sitting at a desk, focused on reading a very long email on their screen. The email has many visible lines of text scrolling down. The figure is leaning forward, concentrating. A small clock in the corner.

RIGHT SIDE - labeled "Decode: Typing the reply, word by word":
Same stick figure, now typing on their keyboard. On the screen, a reply being composed with text appearing letter by letter. Small dots showing text being generated sequentially.

BOTTOM: Text reading "The longer the email, the longer to read it. But typing speed stays the same."
Small annotation: "That's why TTFT depends on input size, not output size."

Style: Simple, clean, hand-drawn whiteboard sketch. Black ink on white. No shading, no fills.
```

**Purpose:** Visualizes the Prefill/Decode analogy — reading an email (parallel input processing) before typing a reply (sequential output generation). Makes TTFT intuitive.

---

## Illustration 4: Terraform Plan/Apply Parallel

**Prompt for Gemini:**

```
Create a black and white hand-drawn sketch illustration, whiteboard style, clean lines, no colors:

Two parallel horizontal pipelines stacked vertically with arrows showing the parallel between them.

TOP PIPELINE - labeled "Terraform Workflow":
Left box: "terraform plan" with small annotation "reads all .tf files, builds dependency graph"
Arrow pointing right to:
Right box: "terraform apply" with small annotation "executes changes one by one"

BOTTOM PIPELINE - labeled "AI Processing":
Left box: "Prefill" with small annotation "reads all tokens, builds understanding"
Arrow pointing right to:
Right box: "Decode" with small annotation "generates response token by token"

Between the two pipelines, dashed vertical lines connecting:
- "terraform plan" to "Prefill" with label "parallel processing"
- "terraform apply" to "Decode" with label "sequential execution"

BOTTOM: Text reading "Plan before apply. Read before write. Same pattern, different domain."

Style: Simple, clean, hand-drawn whiteboard sketch. Black ink on white. No shading, no fills.
```

**Purpose:** Maps the Prefill/Decode phases directly to terraform plan/apply — an operation every DevOps practitioner knows by heart. Makes the abstract processing pipeline concrete.

---

## Illustration 7: The Assembly Line — How Tokens Build Understanding

**Prompt for Gemini:**

```
Create a black and white hand-drawn sketch illustration, whiteboard style, clean lines, no colors:

A factory assembly line scene moving left to right:

STATION 1 (far left): Labeled "Tokenizer" — a conveyor belt with raw words entering, and a worker figure chopping them into smaller pieces (token chunks).

STATION 2: Labeled "Embedding" — a worker figure assigning number tags/coordinates to each token piece on the belt.

STATION 3 (largest, center): Labeled "Attention Layers" — a long table with multiple worker figures (at least 5-6), each one connecting token pieces to other pieces with strings/lines. The table extends along the conveyor belt to show depth of processing.

STATION 4 (far right): Labeled "Output" — finished tokens coming off the assembly line one at a time, polished and complete.

BOTTOM: Text reading "Each token passes through ~100 transformer layers. Like a 100-stage assembly line — each stage adds understanding."
Small note: "More stages = deeper understanding = bigger model"

Style: Simple, clean, hand-drawn whiteboard factory sketch. Black ink on white. Whimsical and clear.
```

**Purpose:** Makes the internal structure of a transformer model intuitive through a factory metaphor. DevOps practitioners understand assembly lines and staged processing.

---

## Illustration 9: Context Window as RAM — There's a Ceiling

**Prompt for Gemini:**

```
Create a black and white hand-drawn sketch illustration, whiteboard style, clean lines, no colors:

A server rack/computer with a prominent memory module (RAM stick) displayed.

The RAM stick is labeled "Context Window" with capacity markings along its length:
- Small section: "8K" (labeled "GPT-3.5 era")
- Medium section: "32K" (labeled "Early 2024")
- Large section: "128K-200K" (labeled "Claude Sonnet / GPT-4o")
- Massive section: "1M" (labeled "Gemini")

Below the server: Two side-by-side comparison boxes:
LEFT BOX - "Container Memory":
A container icon with a memory limit bar. Text: "Exceed the limit → OOMKilled"

RIGHT BOX - "Context Window":
A document/text icon with a token limit bar. Text: "Exceed the limit → tokens dropped or request fails"

BOTTOM: Text reading "More RAM does not equal better performance. More context does not equal better answers."
Annotation: "The sweet spot: enough context for the task, not everything you have."

Style: Simple, clean, hand-drawn whiteboard sketch. Black ink on white. No shading, no fills.
```

**Purpose:** Maps the context window directly to container RAM limits — a concept every DevOps practitioner viscerally understands. Drives home the "right-sizing" message.

---

## Generation Notes

- Use Google AI Studio (gemini.google.com) or the Gemini API with image generation enabled
- Request 1024x768 resolution for consistency with Excalidraw exports
- If the first generation has too many details, re-prompt with "simpler, more minimalistic, fewer details"
- Save as PNG with the naming convention: `03.png`, `04.png`, `07.png`, `09.png`
- These illustrations complement the Excalidraw schematics — they add visual metaphors and scenes that are hard to draw with geometric shapes alone
