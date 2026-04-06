# Gemini Image Generation Briefs — Module 04

> These briefs are for generating illustrations using Google Gemini's image generator.
> **Style mandate:** Black and white, hand-drawn sketch style, minimalistic, pen-on-whiteboard feel.
> No color fills, no gradients. Match the Excalidraw B&W aesthetic used throughout the course.

---

## Brief 1: Diagram 3 — Human as Middleware (3AM Incident)

**Filename:** `03-human-as-middleware.png`

**Gemini prompt:**

> Create a black and white hand-drawn technical sketch showing the concept of "human as middleware" during a 3am incident. In the center, draw a tired stick figure sitting at a desk with a coffee cup, with a wall clock showing 3:00 AM. Around the figure, draw 5 floating terminal/screen windows arranged in a circle: one labeled "kubectl" showing pod output, one labeled "psql" showing a query, one labeled "aws cli" showing an alarm, one labeled "gh cli" showing a commit, one labeled "grafana" showing a metric graph. Draw dotted lines connecting each screen THROUGH the human figure, showing that the human is the central hub routing data between all 5 tools. The human has a clipboard with messy handwritten notes. Add arrows showing copy-paste gestures between screens. Caption at bottom: "You are the integration layer. At 3am. With 5 tabs open." Small annotation in corner: "What if the agent could do this?" Style: clean hand-drawn whiteboard sketch, black ink on white, no colors, relatable and slightly humorous.

---

## Brief 2: Diagram 4 — USB-C Analogy (One Connector for Everything)

**Filename:** `04-usb-c-analogy.png`

**Gemini prompt:**

> Create a black and white hand-drawn sketch showing the USB-C analogy for MCP (Model Context Protocol). Split into two halves with a dividing line. LEFT HALF labeled "Before USB-C": draw a messy tangle of 6 different cable types (USB-A, Mini-USB, Micro-USB, Lightning, HDMI, proprietary barrel connector), each going from a different device (phone, monitor, laptop, camera, tablet, headphones) to a tangled knot in the center. The cables are a chaotic mess. RIGHT HALF labeled "After USB-C": draw a single clean USB-C cable going from a neat hub/dock to all the same devices, with clean parallel lines. The hub has one input port. Between the two halves, a large arrow labeled "MCP does this for AI." At the bottom, show the math: "Before: N tools × M agents = N×M integrations" crossed out, replaced by "After: N tools + M agents = N+M connections." Style: clean hand-drawn whiteboard sketch, black pen on white, no colors, the contrast between messy-left and clean-right should be visually obvious.

---

## Brief 3: Diagram 7 — The Tool Discovery Dance

**Filename:** `07-tool-discovery-dance.png`

**Gemini prompt:**

> Create a black and white hand-drawn sketch showing two characters doing a "discovery dance." On the left, draw a robot/agent figure (simple, friendly) with a speech bubble saying "What can you do?" On the right, draw a figure wearing a name tag that says "kubectl MCP Server" holding up a menu board that lists: "I can: get pods, get logs, describe resources, check events, list namespaces." Between them, show a handshake labeled "Discovery Protocol" with sparkle lines suggesting a successful connection. Below the scene, show the robot with a thought bubble containing a decision tree: "If user asks about crashes → use get_logs + describe_resource. If user asks about capacity → use get_pods + resource metrics." Caption at bottom: "Self-describing interfaces. The agent learns what tools are available at runtime." Small annotation: "Just like K8s service discovery." Style: whimsical hand-drawn sketch, black pen on white, friendly characters, technical but approachable.

---

## Brief 4: Diagram 9 — The MCP Ecosystem (Servers for Everything)

**Filename:** `09-mcp-ecosystem.png`

**Gemini prompt:**

> Create a black and white hand-drawn sketch showing the MCP ecosystem as a hub-and-spoke diagram. In the center, draw a hexagonal hub labeled "Your AI Agent" with a small USB-C port symbol on it. Radiating outward like spokes from the hub, draw 12 connections to labeled MCP server nodes arranged in a clock-like circle. The nodes are: kubectl (with a tiny ship wheel icon), postgres (tiny elephant), mysql (tiny dolphin), github (tiny octocat), gitlab (tiny fox), aws (tiny cloud), docker (tiny whale), prometheus (tiny fire icon), grafana (tiny eye icon), slack (tiny hashtag), jira (tiny ticket icon), filesystem (tiny folder icon). Each node is a small rounded rectangle with the name and icon. Draw small lightning bolt symbols on each spoke to show active connections. At the bottom outside the circle: "200+ community servers and growing" and directory links: "mcp.run | smithery.ai | awesome-mcp-servers". Style: clean hand-drawn whiteboard sketch, black ink on white, no colors, professional but readable, emphasize the breadth of the ecosystem.

---

## Usage Notes

1. Generate each image at 1920x1080 or 1600x1200 for presentation quality
2. If Gemini adds color despite the prompt, regenerate with emphasis on "black and white only, no color"
3. Save generated images in this `diagrams/` directory alongside the Excalidraw files
4. These complement the Excalidraw diagrams — use Excalidraw for schematic/flow diagrams, Gemini illustrations for visual metaphors and scenes
