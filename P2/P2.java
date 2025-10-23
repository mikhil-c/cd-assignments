import syntaxtree.*;
import visitor.*;

public class P2 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         GJNoArguDepthFirstPass1<String> v1 = new GJNoArguDepthFirstPass1<>();
         root.accept(v1);
         GJDepthFirstPass2<String, Void> v2 = new GJDepthFirstPass2<>();
         v2.symbolTable = v1.symbolTable;
         root.accept(v2, null);
         System.out.println("Program type checked successfully");
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
