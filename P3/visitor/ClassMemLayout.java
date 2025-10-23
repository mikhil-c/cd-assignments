package visitor;
import java.util.*;

class ClassMemLayout {
    ClassMemLayout() {
        name = new String();
        fields = new HashMap<>();
        declClass = new HashMap<>();
        vtable = new HashMap<>();
        parent = null;
    }
    public String name;                       // class name
    public HashMap<String, Integer> fields;   // fields -> index
    public HashMap<String, String> declClass; // fields -> latest class in which they are declared
    public HashMap<String, Integer> vtable;   // function -> index
    public String parent;                     // parent class
}
