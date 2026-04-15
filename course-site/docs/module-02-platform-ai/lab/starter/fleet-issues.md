# Broken Fleet — Issues Catalog (Instructor Answer Key)

This document lists every intentional misconfiguration in `broken-fleet.yaml` and maps each one to the tool(s) that should surface it. Use it to verify learners' triage work and to calibrate tool coverage during the lab.

> **Keep this out of learner-visible paths during live delivery.** It's published alongside the stack for instructor reference and for self-paced learners who want to check their work after attempting the lab.

---

## Compute-layer issues (baked into user-data)

### #E-1 — `alpha-noisy`: pinned CPU
**What:** A `cpu-burn.service` systemd unit runs `stress-ng --cpu 2 --cpu-method matrixprod` with `Restart=always`. Saturates both logical CPUs permanently.
**Time to manifest:** Immediate on boot; visible in CloudWatch within ~5–10 min.
**Detected by:**
- CloudWatch native `AWS/EC2 CPUUtilization` → pre-created alarm `alpha-cpu-high` fires.
- DevOps Guru → "High CPU" insight after baseline learning.
- Amazon Q Developer → catches the systemd unit in user-data on code review.
**Not detected by:** Native CloudWatch memory/disk (those dimensions don't exist without the agent).

### #E-2 — `beta-leaky`: memory leak
**What:** A Python script `/usr/local/bin/leak.py` appends an 80 MB `bytearray` to a list every 60 seconds, run under systemd as `mem-leak.service`.
**Time to manifest:** Hits 75% of 1 GB RAM in ~8–10 minutes.
**Detected by:**
- CloudWatch Agent custom metric `PlatformAILab/mem_used_percent` → alarm `beta-mem-high` fires.
- Datadog system.mem.pct_usable (if agent installed).
- Amazon Q → spots the unbounded `buf.append` pattern on code review.
**Not detected by:** Native CloudWatch (no memory metric). This is the key teaching gap.

### #E-3 — `gamma-disk`: disk filling
**What:** Two cron jobs in `/etc/cron.d/lab-disk`: one fills `/var/lab-fill/` with 40 MB of random data every minute; the other runs a small script that reads `df /` and publishes a custom CloudWatch metric `PlatformAILab/data_fill_percent` with only `InstanceId` as a dimension.
**Time to manifest:** Root filesystem utilization climbs a few % per minute. Alarm threshold 50% typically trips within 5–10 minutes depending on the AMI's initial free space.
**Why a custom metric instead of CW Agent disk plugin:** The agent's disk plugin publishes with four dimensions (`InstanceId`, `path`, `device`, `fstype`). Alarms require exact dimension-tuple match; specifying only `InstanceId` + `path` leaves the alarm in INSUFFICIENT_DATA. The custom script controls its own dimensions.
**Detected by:**
- CloudWatch custom metric `PlatformAILab/data_fill_percent` → alarm `gamma-disk-full` fires.
- Datadog system.disk.in_use (if agent installed).
- `df -h` on the host; `systemctl status cron` will show the fill jobs running.
**Not detected by:** Native CloudWatch (no disk metric without an agent or custom publisher).

### #E-4 — `gamma-disk`: broken fstab entry
**What:** User-data appends `UUID=00000000-dead-beef-... /broken xfs defaults 0 2` to `/etc/fstab`. On the running instance this is harmless (only affects reboots), but `mount -a` and `systemctl --failed` both report the error.
**Time to manifest:** Visible in `journalctl -xe` and `systemctl status local-fs.target` at any time after boot. Would block reboot completely.
**Detected by:**
- Manual inspection via SSH.
- Amazon Q Developer → asking "review this system, is anything wrong?" with the fstab pasted in.
- Would be caught by AWS Systems Manager State Manager if that were enabled (not in this lab).
**Not detected by:** CloudWatch or DevOps Guru — it's a configuration-state issue, not a metrics issue.

---

## Network-layer issues (baked into the VPC/SG resources)

### #S-1 — `PermissiveSg`: SSH open to the world
**What:** The security group attached to `alpha-noisy` allows `tcp/22` from `0.0.0.0/0` regardless of the `AllowedSshCidr` parameter.
**Detected by:**
- Amazon Q Developer → should flag this immediately on template review.
- AWS Trusted Advisor → "Security groups — unrestricted access" check.
- AWS Config (if enabled) via managed rule `restricted-ssh`.
**Not detected by:** CloudWatch (not a metrics issue), DevOps Guru (not an operational anomaly).

---

## Coverage matrix

| Issue | CloudWatch (native) | CloudWatch Agent / custom metric | Amazon Q (console) | DevOps Agent | Datadog (optional) |
|---|:-:|:-:|:-:|:-:|:-:|
| #E-1 CPU burn | ✅ | ✅ | ✅ | ✅ | ✅ |
| #E-2 Memory leak | ❌ | ✅ (CW agent) | ✅ | ✅ (with CW agent metric) | ✅ |
| #E-3 Disk fill | ❌ | ✅ (custom publisher) | ⚠️ (cron is subtle) | ✅ (with custom metric) | ✅ |
| #E-4 Broken fstab | ❌ | ❌ | ✅ | ❌ | ❌ |
| #S-1 SSH 0.0.0.0/0 | ❌ | ❌ | ✅ | ⚠️ if investigation touches SG | ❌ |

**Teaching takeaway:** No single tool catches everything. CloudWatch is strong on metrics but blind to code/config issues. Amazon Q is strong on code/config review but doesn't watch live metrics on a loop. DevOps Agent is the closest to a "full loop" (detect → investigate → hypothesize → recommend), but it still can't cross the ceiling into *your* runbook, *your* ticketing, or *your* escalation policy. That ceiling is where custom agents (Module 3+) earn their keep.

**Note on naming confusion:** AWS "DevOps Guru" (2020) and AWS "DevOps Agent" (GA 2026-03-31) are different products. Guru is passive anomaly detection; Agent is an investigation-and-action loop surfaced as CloudWatch Investigations. This lab uses DevOps Agent for the tool pass because it's the newer, more capable option and the better foil for the module's thesis.

---

## Tuning notes

If you want to accelerate the timing for a short lab session:
- **Memory leak:** change the sleep in `leak.py` from `60` to `20` seconds → hits 75% in ~3 minutes.
- **Disk fill:** change the `dd count` from `40` to `100` → hits 80% in ~8 minutes.
- **CW alarms:** reduce `EvaluationPeriods` from 1 to `1` with a shorter `Period` if you're willing to enable detailed monitoring (not free).

For a longer, more realistic triage exercise, leave the defaults.
