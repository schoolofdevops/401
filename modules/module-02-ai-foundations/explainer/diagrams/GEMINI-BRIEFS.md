# Gemini Image Generation Briefs — Module 02

> These briefs are for generating illustrations using Google Gemini's image generator.
> **Style mandate:** Black and white, hand-drawn sketch style, minimalistic, pen-on-whiteboard feel.
> No color fills, no gradients. Match the Excalidraw B&W aesthetic used throughout the course.

---

## Brief 1: Diagram 3 — Tokenization (Log Parsing Analogy)

**Filename:** `03-tokenization-log-parsing.png`

**Gemini prompt:**

> Create a black and white hand-drawn technical sketch showing the concept of "tokenization" in AI through a log parsing analogy. On the left, show a block of raw JSON text (with visible curly braces, colons, quotes) flowing as a continuous stream. In the center, show a "parser" or scissors cutting the stream into small labeled token chunks: ["Kubern", "etes", "{", "Alarm", "Name"]. On the right, show the tokens flowing into a neat row of small rounded rectangles, each with a count number below. Include a simple equation at the bottom: "Kubernetes = 2 tokens" and "800 chars JSON = ~200 tokens". Add a note: "~3-4 characters per token. JSON is expensive." Style: clean hand-drawn whiteboard sketch, black ink on white, no colors, technical but approachable.

---

## Brief 2: Diagram 5 — Context Window OOM (Container Overflowing)

**Filename:** `05-context-window-oom.png`

**Gemini prompt:**

> Create a black and white hand-drawn sketch showing a tall container (like a Docker container or jar) labeled "200K tokens" at the rim. Inside the container, stacked data blocks are being poured in, labeled "Alarm 1", "Alarm 2" through "Alarm 50" (halfway). Data keeps piling above the rim — Alarms 51-100 are spilling over the edge and falling outside. The container shows stress cracks near the top. Include a thought bubble from the container: "365K tokens... I can only hold 200K!" Add a small Docker whale icon on the side with "OOM Killed" text, connected by an equals sign to the overflowing container. Bottom annotation: "100 alarms x 3,650 tokens = 365K. Context management is survival." Style: whimsical but clear hand-drawn sketch, black pen on white paper, no colors, technical humor.

---

## Brief 3: Diagram 8 — War Room Whiteboard

**Filename:** `08-war-room-whiteboard.png`

**Gemini prompt:**

> Create a black and white hand-drawn sketch of an incident war room scene. Prominently in the center, draw a large whiteboard divided into labeled sections: "System Prompt / Identity" (top-left), "Conversation History" (left column with chat message lines), "Tool Results" (right column with kubectl and aws output snippets), "Current Task" (center, highlighted), and "Room Remaining" (empty bottom area). Show a simple stick figure (representing the AI/LLM) standing in front of the whiteboard, focused only on it. Around the room, show crossed-out or ghosted items the AI CANNOT see: a laptop labeled "Grafana dashboards" (X over it), a phone labeled "Slack history" (X over it), a bookshelf labeled "Confluence wiki" (X over it). Caption at bottom: "The model can ONLY see the whiteboard. Everything else is invisible. YOU decide what goes on it." Style: warm pen-on-whiteboard sketch, black and white only, simple stick figures, clean labels.

---

## Brief 4: Diagram 14 — Token Economics (Balance Scale)

**Filename:** `14-token-economics-balance.png`

**Gemini prompt:**

> Create a black and white hand-drawn sketch of a balance scale showing the business case for AI-assisted operations. Left pan (tilted up, lighter): labeled "AI Agent" with a small stack of coins "$1.50/day", notation "500 alarms x $0.003 each", and a small robot icon. Right pan (tilted down, heavier): labeled "Manual Triage" with a large pile of dollar signs "$3,000+/day", notation "500 alarms x 5 min = 41.7 hrs/day", and 5+ stressed stick figures. Above the scale: "Same 500 alarms. Same quality. Very different cost." On the side, show a small receipt: "Input: $1.50 + Output: $3.75 = $5.25/day. Free option: Gemini = $0." Bottom: "Context engineering IS cost engineering." Style: whimsical hand-drawn balance scale, pen sketch on white, no colors, clear labels, technical but friendly.

---

## Usage Notes

1. Generate each image at 1920x1080 or 1600x1200 for presentation quality
2. If Gemini adds color despite the prompt, regenerate with emphasis on "black and white only, no color"
3. Save generated images in this `diagrams/` directory alongside the Excalidraw files
4. These complement the Excalidraw diagrams — use Excalidraw for schematic/flow diagrams, Gemini illustrations for visual metaphors
