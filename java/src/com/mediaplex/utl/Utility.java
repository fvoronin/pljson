package com.mediaplex.utl;

import java.sql.Array;
import java.sql.Connection;
import java.util.Iterator;
import java.util.Vector;

import oracle.jdbc.OracleDriver;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;

public class Utility {

  public static void splitString(String stringToSplit, String regEx, String trimStrings, String trimArray,
      Array[] rslt, String[] errText) {
    try {
      if (stringToSplit == null)
        return;

      boolean trmStrings = (trimStrings != null) && (trimStrings.equals("*"));
      boolean trmArray = (trimArray != null) && (trimArray.equals("*"));

      String[] array = stringToSplit.split(regEx);

      if (trmStrings || trmArray) {
        Vector<String> vector = new Vector<String>();
        for (String str : array) {

          if (trmStrings) {
            if (str != null)
              str = str.trim();
          }

          if (trmArray) {
            if (str != null && str.length() > 0)
              vector.add(str);
          } else
            vector.add(str);
        }

        array = new String[vector.size()];
        Iterator<String> i = vector.iterator();
        int indx = 0;
        while (i.hasNext()) {
          array[indx++] = i.next();
        }
      }

      Connection conn = new OracleDriver().defaultConnection();
      rslt[0] = new ARRAY(ArrayDescriptor.createDescriptor("STRARRAY", conn), conn, array);

    } catch (Exception e) {
      errText[0] = e.getLocalizedMessage();
    }
  }

}
