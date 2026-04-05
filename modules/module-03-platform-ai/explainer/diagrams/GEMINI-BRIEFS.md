# Gemini Image Generation Briefs — Module 03

> These briefs are for generating illustrations using Google Gemini's image generator.
> **Style mandate:** Black and white, hand-drawn sketch style, minimalistic, pen-on-whiteboard feel.
> No color fills, no gradients. Match the Excalidraw B&W aesthetic used throughout the course.

---

## Brief 1: Diagram 3 — The Mechanic Checking the Toolkit

**Filename:** `03-mechanic-checking-toolkit.png`

**Gemini prompt:**

> Create a black and white hand-drawn technical sketch of a mechanic (in overalls) opening a large toolbox labeled "Your Stack." Inside the toolbox are various AI tools, each labeled: "CloudWatch Anomaly", "Cost Explorer AI", "Q Developer", "Grafana Sift", "Copilot." Some tools have cobwebs on them (indicating they're unused/forgotten), while one or two tools are shiny and clean (already in use). The mechanic holds a checklist that reads "Step 1: Know what you have." Below the scene, a caption reads: "Before you build new tools, check the ones in your toolbox." Style: warm pen-on-whiteboard sketch, black and white only, no colors, simple but expressive character, clean labels. Technical but approachable.

---

## Brief 2: Diagram 4 — CloudWatch Anomaly Detection in Action

**Filename:** `04-cloudwatch-anomaly-in-action.png`

**Gemini prompt:**

> Create a black and white hand-drawn technical sketch showing how CloudWatch Anomaly Detection works — and where it stops. At the top, draw a line graph showing a smooth metric with a gray "normal band" and a dramatic spike breaking above the band. The spike has a speech bubble saying "Something is wrong!" Below the graph, draw a horizontal conveyor belt with four stations: Station 1 "Alert Fires" (with a bell icon, complete), Station 2 "SNS Notification" (with an envelope icon, complete), Station 3 is a giant "???" with a construction barrier and caution tape, Station 4 "Engineer SSHs in manually" (stick figure at a terminal, looking tired). The gap between Station 2 and Station 4 is labeled "Investigation, Correlation, Remediation — ALL MANUAL." Bottom caption: "It detects. It alerts. Then it stops." Style: clean hand-drawn whiteboard sketch, black ink on white, no colors, technical but approachable, light humor.

---

## Brief 3: Diagram 7 — The Ceiling (Building Cross-Section)

**Filename:** `07-platform-ai-ceiling.png`

**Gemini prompt:**

> Create a black and white hand-drawn sketch of a building cross-section with four visible floors, showing where platform AI capability stops. Ground floor (Floor 1): labeled "DETECTION" — well-lit with desk lamps, chairs, AI tool icons (CloudWatch, Datadog logos simplified), busy and occupied. Floor 2: labeled "INVESTIGATION" — partially lit, sparse furniture, a few scattered tools, half-occupied. Floor 3: labeled "ACTION & REMEDIATION" — dark and empty, with a prominent "UNDER CONSTRUCTION" sign and construction barriers. Floor 4 (penthouse): labeled "YOUR CONTEXT (Runbooks, Topology, SLAs)" — completely dark with a padlocked door. On the right side of the building, draw an elevator shaft with an elevator labeled "Custom Agent" that goes all the way from ground to penthouse, with a glowing arrow pointing up. Caption at bottom: "Platform AI lives on the ground floor. Custom agents take the elevator to the penthouse." Style: architectural sketch feel, pen on white paper, no colors, clear floor labels, whimsical but informative.

---

## Brief 4: Diagram 11 — Three-Way Comparison (Manual vs Platform AI vs Custom Agent)

**Filename:** `11-three-way-comparison.png`

**Gemini prompt:**

> Create a black and white hand-drawn sketch showing three columns comparing responses to the same incident: "CPU spike on production API server." Column 1 "MANUAL": A stressed stick figure engineer surrounded by 5 open terminal windows, Slack messages flooding in, Grafana dashboard on screen, a clock showing "45 min." The figure is juggling multiple tools. Caption below: "Context is in your head." Column 2 "PLATFORM AI": A CloudWatch alert bell ringing, Cost Explorer showing "no unusual spend", Q Developer suggesting "check resource limits." The same stick figure is still at the keyboard but less frantic. Clock shows "15 min." Caption: "Detection automated. Investigation still on you." Column 3 "CUSTOM AGENT": A robot/agent icon reading an alarm, checking deployments (git log), querying metrics, following a flowchart (runbook), creating a Jira ticket with a structured diagnosis. Clock shows "3 min." Caption: "Context is in SKILL.md. Investigation is automated." Bottom text spanning all three: "Same incident. Three responses. The difference? Context." Style: hand-drawn comparison layout, pen sketch on white, no colors, clear column separation, technical humor.

---

## Usage Notes

1. Generate each image at 1920x1080 or 1600x1200 for presentation quality
2. If Gemini adds color despite the prompt, regenerate with emphasis on "black and white only, no color"
3. Save generated images in this `diagrams/` directory alongside the Excalidraw files
4. These complement the Excalidraw diagrams — use Excalidraw for schematic/flow diagrams, Gemini illustrations for visual metaphors
