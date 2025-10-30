package visitor;
import java.util.*;

class LiveRange {
    LiveRange() {
        min = Integer.MAX_VALUE;
        max = Integer.MIN_VALUE;
    }
    public int min;
    public int max;
}
