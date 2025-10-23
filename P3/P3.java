import syntaxtree.*;
import visitor.*;

public class P3 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         Pass1<Object, Object> v1 = new Pass1<>();
         root.accept(v1, null);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
