import syntaxtree.*;
import visitor.*;

public class P4 {
   public static void main(String [] args) {
      try {
         Node root = new MiniIRParser(System.in).Goal();
         Pass1 v = new Pass1<>();
         root.accept(v, null);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 


