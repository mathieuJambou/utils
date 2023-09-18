package com.equisoft.function.util;

import java.io.PrintWriter;
import java.io.StringWriter;

public class LoggingUtils {

    public static String getStackTrace(Throwable throwable) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw, true);
        throwable.printStackTrace(pw);
        return sw.getBuffer().toString();
    }
}
