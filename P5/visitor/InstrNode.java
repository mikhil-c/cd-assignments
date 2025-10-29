package visitor;
import java.util.*;

class InstrNode {
    InstrNode() {
        def = new HashSet<>();
        use = new HashSet<>();
    }
    public HashSet<String> def;
    public HashSet<String> use;
}
