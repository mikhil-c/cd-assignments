import syntaxtree.*;
import visitor.*;

public class P5 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 
