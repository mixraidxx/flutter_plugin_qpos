package com.dspread.flutter_plugin_qpos;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

public class ReflectPares {
    /**
     * this program uses reflection to print all features of a class.
     *
     * @version 1.1 2004-02-01
     * @author Cay Horstmann
     * @deprecated 关于反射：利用反射分析类的能力：（反射机制最重要的内容——检查类结构）
     */
    public static void main(String[] args) {
// TODO Auto-generated method stub
//read class name from command line args or user input
        String name = QPOSServiceListenerImpl.class.getName();

        try {

//print class name and superclass name (if!=object)
            Class cl = Class.forName(name);
            Class supercl = cl.getClass();
            pareasMethods(cl);
//            String modifiers = Modifier.toString(cl.getModifiers());
//            if (modifiers.length() > 0) System.out.print(modifiers + " ");
//            System.out.print("class " + name);
//            if (supercl != null && supercl != Object.class) {
//                System.out.println(" extends " + supercl.getName());
//                System.out.print("{");
//
////System.out.println("------------------------printConstructors()is begin!------------------------");
//                printConstructors(cl);
////System.out.println("------------------------printConstructors()is end!------------------------");
//                System.out.println();
//
////System.out.println("------------------------printMethods()is begin!------------------------");
//                printMethods(cl);
////System.out.println("------------------------printMethods()is end!------------------------");
//                System.out.println();
//
////System.out.println("------------------------printFields()is begin!------------------------");
//                printFields(cl);
////System.out.println("------------------------printFields()is end!------------------------");
//
//                System.out.println("}");
//            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        System.exit(0);

    }

    /**
     * prints all constructors of a class
     *
     * @param cl a class
     */
    public static void printConstructors(Class cl) {
        Constructor[] constructors = cl.getDeclaredConstructors();

        for (Constructor c : constructors) {
            String name = c.getName();
            System.out.println(" ");
            String modifiers = Modifier.toString(c.getModifiers());
            if (modifiers.length() > 0) System.out.print(modifiers + " ");
            System.out.print(name + "(");

//print parameter types
            Class[] paramTypes = c.getParameterTypes();
            for (int j = 0; j < paramTypes.length; j++) {
                if (j > 0) System.out.print(" ,");
                System.out.print(paramTypes[j].getName());
            }
            System.out.print(");");
        }
    }

    /**
     * print all methods of a class
     * param cl is a class
     */
    public static void printMethods(Class cl) {
        Method[] methods = cl.getDeclaredMethods();

        for (Method m : methods) {
            Class retType = m.getReturnType();
            String name = m.getName();

            System.out.println(" ");
//print modifiers ,return type,and method name
            String modifiers = Modifier.toString(m.getModifiers());
            if (modifiers.length() > 0) {
                System.out.print(modifiers + " " + retType.getName() + " " + name + "(");
//print parameter types
                Class[] paramTypes = m.getParameterTypes();
                for (int j = 0; j < paramTypes.length; j++) {
                    if (j > 0) {
                        System.out.print(",");
                    }
                    System.out.print(paramTypes[j].getName());
                }
                System.out.println(");");
            }
        }
    }

    /**
     * print all fields of a class
     *
     * @param cl
     */
    public static void printFields(Class cl) {
        Field[] fields = cl.getDeclaredFields();

        for (Field f : fields) {
            Class type = f.getType();
            String name = f.getName();
            System.out.print(" ");
            String modifiers = Modifier.toString(f.getModifiers());
            if (modifiers.length() > 0) System.out.print(modifiers + " ");
            System.out.println(type.getName() + " " + name + " ;");
        }
//	System.out.println("	printFields()is ends!");
    }


    public static void pareasMethods(Class cl) {
        Method[] methods = cl.getDeclaredMethods();

        for (Method m : methods) {
            String name = m.getName();
//            case ' ':
            System.out.print("case '"+name+"':");
            System.out.println();
            System.out.print("break;");
            System.out.println();

        }
    }



}



