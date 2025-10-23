package visitor;
import java.util.*;

public class Method {
   public Method() {
       name = new String();
       returnType = new String();
       paramList = new ArrayList<String>();
       paramType = new HashMap<String, String>();
       localVar = new HashMap<String, String>();
   }
   String name;                        // Name of the method
   String returnType;                  // Return type
   ArrayList<String> paramList;        // List of parameters
   HashMap<String, String> paramType;  // Parameter -> Type
   HashMap<String, String> localVar;   // Local variable -> Type
}
