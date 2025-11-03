import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P5 {
   public static void main(String [] args) {
      try {
         Node root = new microIRParser(System.in).Goal();
         Pass1<Object, Object> v1 = new Pass1<>();
         root.accept(v1, null);

         N = v1.instr;
         scopeList = v1.scopeList;
         roots = v1.roots;
         arity = v1.arity;
         liveRange = v1.liveRange;

         linearScanRegisterAllocation();

         Pass2 v2 = new Pass2<>();
         v2.labelMap = v1.labelMap;
         v2.regMap = regMap;
         v2.stackSpace = stackSpace;
         root.accept(v2, null);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }

   // fields used for storing the data from Pass1
   private static int N;
   private static ArrayList<String> scopeList = new ArrayList<>();
   private static ArrayList<Integer> roots = new ArrayList<>();
   private static ArrayList<Integer> arity = new ArrayList<>();
   private static HashMap<String, HashMap<String, LiveRange>> liveRange = new HashMap<>();

   // fields used for register allocation
   private static TreeSet<LiveRange> active;
   private static final int R = 18;
   private static Stack<String> registers;
   private static int currLoc = 1; // stores the current memory location

   private static HashMap<String, HashMap<String, String>> regMap = new HashMap<>(); // scope -> temp -> reg
   private static HashMap<String, Integer> stackSpace = new HashMap<>();             // scope -> stack space used

   private static void linearScanRegisterAllocation() {
       // allocating registers based on the scope
       for (int i = 0; i < scopeList.size(); ++i) {
           String currScope = scopeList.get(i);
           HashMap<String, String> currRegMap = new HashMap<>(); 

           // initialising with the available registers
           registers = new Stack<>();
           for (int j = 0; j < 8; ++j) {
               registers.push("s" + j);
           }
           for (int j = 0; j < 10; ++j) {
               registers.push("t" + j);
           }

           // initialising active
           active = new TreeSet<>((a, b) -> {
               return (a.max != b.max) ? (a.max - b.max) : (a.min - b.min);
           });

           // assigning registers to the arguments
           for (int j = 0; j < arity.get(i); ++j) {
               if (j < 4) {
                   currRegMap.put("TEMP " + j, "a" + j);
               }
               else {
                   currRegMap.put("TEMP " + j, "" + currLoc);
                   ++currLoc;
               }
           }
           if (!currScope.equals("MAIN")) {
               currLoc += 18;
           }

           // to get the live intervals sorted in the order of increasing start point(min)
           ArrayList<LiveRange> liveInterval = new ArrayList<>();
           for (LiveRange currRange : liveRange.get(currScope).values()) {
               if (!currRange.isArgu(arity.get(i))) {
                   liveInterval.add(currRange);
               }
           }
           liveInterval.sort((a, b) -> {
               return (a.min != b.min) ? (a.min - b.min) : (a.max - b.max);
           });

           // iterating over the sorted live intervals
           for (LiveRange currRange : liveInterval) {
               expireOldIntervals(currRange);
               if (active.size() == R) {
                   spillAtInterval(currRange);
               }
               else {
                   currRange.reg = registers.pop();
                   active.add(currRange);
               }
           }

           for (LiveRange currRange : liveInterval) {
               if (currRange.isSpilled) {
                   currRegMap.put(currRange.temp, "" + currRange.loc);
               }
               else {
                   currRegMap.put(currRange.temp, currRange.reg);
               }
           }

           stackSpace.put(currScope, currLoc - 1);

           currLoc = 1;
           regMap.put(currScope, currRegMap);
       }
   }

   private static void expireOldIntervals(LiveRange interval) {
       while (active.size() != 0) {
           LiveRange firstInterval = active.first();
           if (firstInterval.max >= interval.min) {
               return;
           }
           registers.push(firstInterval.reg);
           active.remove(firstInterval);
       }
   }

   private static void spillAtInterval(LiveRange interval) {
       LiveRange lastInterval = active.last();
       if (lastInterval.max > interval.max) {
           interval.reg = lastInterval.reg;
           lastInterval.isSpilled = true;
           lastInterval.reg = "";
           lastInterval.loc = currLoc++;
           active.remove(lastInterval);
           active.add(interval);
       }
       else {
           interval.loc = currLoc++;
       }
   }

   // for debug
   private static void print_allocatedRegs() {
       for (Map.Entry<String, HashMap<String, String>> entry : regMap.entrySet()) {
           System.out.println(entry.getKey());
           HashMap<String, String> currMap = entry.getValue();
           for (Map.Entry<String, String> e : currMap.entrySet()) {
               System.out.println(e.getKey() + " -> " + e.getValue());
           }
           System.out.println();
       }
   }
}
