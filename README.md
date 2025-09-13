# Smart-Appliance-Scheduling-for-Cost-and-Demand-Reduction
### Main Script to Run
**`final_demo.m`** is the **main script**.  
Run it **after** ensuring the files `printer.m` and `reschedule.m` are saved in the **same folder**.

---

### Purpose
This project optimizes the electricity cost and load balancing for smart appliances using **Mixed-Integer Linear Programming** (MILP).

---

### Files Overview

 File Name          Purpose 
----------------------------
 `final_demo.m`  -   Main driver script. Handles input, optimization and load scheduling. 
 `printer.m`     -   Visualizes and prints the optimized schedule, energy, cost, and mismatch. 
 `reschedule.m`  -   Dynamically modifies schedule based on user input (on/off of an appliance). 

---

### How to Use

1. **Choose the desired dataset (LS1, LS2, LS3, or LS4)**  
   - Inside `final_demo.m`, uncomment the block for the dataset you want to run.  
   - **Comment out the other datasets**.

2. **Run `final_demo.m`** in MATLAB:
   - It will display the optimized schedule and ask for user input for dynamic rescheduling.

3. **Dynamic Rescheduling**  
   After schedule generation, the script asks:
   ```
   Enter 0 to exit and press any another key to continue reschedulling:
   ```
   - **Enter `0`** to exit.  
   - **Press any other key** to continue dynamic rescheduling:
     - You'll be prompted to:
       - Enter `1` to turn ON or `0` to turn OFF an appliance.
       - Enter the current slot.
       - Enter the appliance ID (from 1 to 10).
     - The schedule will be re-optimized accordingly.

---

### Inputs

- `DA`: Power demand per appliance.
- `cost`: Per-slot cost of electricity.
- `load`: Power consumption of appliances over all slots.
- `time_slots`: Number of slots the appliance is needed to be in `ON` state.
- `E_max`: Maximum energy allowed per slot.
- `alpha`, `beta`: Weights to control influence of priority and energy usage.
- `priority` : Assigns priorities to appliances in each slot.
---
