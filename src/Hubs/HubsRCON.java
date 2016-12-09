package Hubs;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Павел
 */

import java.util.Scanner;

public class HubsRCON {
    
    public static class HubsRConComand{
     public static String cmd;   
     public static String[] args;
     
     public void parse(String s)
     {
      int ind=0,i=0;
      this.cmd=s.substring(1,s.indexOf(' '));
      s=s.substring(s.indexOf(' ')+1).trim();
      boolean Ampersant=false;
      while (i!=s.length()-1){
       if(this.args.length<ind+1){
        String[] copyArgs=args;
        args=new String[copyArgs.length+1];
        for (int j=0; j<copyArgs.length; j++){
         args[j]=copyArgs[j];
        }   
       }
       if (s.charAt(i)=='"'){
        Ampersant=!Ampersant;
       }
        else
       if (s.charAt(i)!=' ')
       {
         this.args[ind]+=s.charAt(i);  
       } else {
        ind++;
        while(s.charAt(i+1)==' ')
        {
         i++;
        }
       }
       i++;
      }
     }
     
    }
    
    public static String HubsRConCMDLine(String s){
     HubsRConComand c=new HubsRConComand();
     c.parse(s);
     switch (c.cmd){
         case ("cls"):System.out.print("\033[H\033[2J");System.out.flush();break;
         case ("exit"):System.exit(0);
     }
     return "Hubs.RCon command does'n t exist!";
    }
    
    public static String ParseMCResultString(String s){
     while(s.contains("§"))
     {
      s=s.substring(0,s.indexOf("§"))+s.substring(s.indexOf("§")+2);
     }   
      s.replaceAll("\n\n","\n");
      return s;  
    }
    
    public static Scanner sc = new Scanner(System.in);
    
    public static void runRCon(String IP, int Port, byte[] password)
    {
        try {
            Rcon rcon = new Rcon(IP, Port, password);
            System.out.println("# HubsRCon connected to "+IP+":"+Port+" successful!");
            String r;
            while(true){
                System.out.print("> ");
                r=sc.nextLine();
                if (r.length()!=0){
                 //if (r.charAt(0)=='.'){
                     //System.out.println("# "+HubsRConCMDLine(r));
                 //} else {
                  r=ParseMCResultString(rcon.command(r));
                  if (r.length()>0){
                   System.out.println("$ "+r);
                  }
                 //}
                }
            }
        } catch (IOException ex) {
            Logger.getLogger(HubsRCON.class.getName()).log(Level.SEVERE, null, ex);
        } catch (AuthenticationException ex) {
            Logger.getLogger(HubsRCON.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public static void main(String[] args) {
      if (args.length==0)
       {
        System.out.println("[HUBS.DEV]\n Hubs RCon client v1.1\n http://hubs.cf\n Autor: pavel151\n Mail: pavel151@inbox.ru\nUse: <HubsRCON> [Args]\nArgs:\n -connect <IP> <Port> <Password>\n -send <IP> <Port> <Password> <Comand>\n________________________\nPress enter...");
        sc.nextLine();
        System.out.print("Connect to RCon server.\nIP      : ");
        String IP=sc.nextLine();
        System.out.print("Port    : ");
        int Port=sc.nextInt();
        System.out.print("Password:");
        String Pass=sc.nextLine();
        runRCon(IP, Port, Pass.getBytes());
       }
       switch (args[0].toLowerCase()){
           case "-connect":
               runRCon(args[1], Integer.parseInt(args[2]), args[3].getBytes());
               break;
           case "-send":
               try {
                Rcon rcon = new Rcon(args[1], Integer.parseInt(args[2]), args[3].getBytes());
                System.out.println("# HubsRCon connected to "+args[1]+":"+args[2]+" successful!\n# Sending command \""+args[4]+"\"...");
                String r=ParseMCResultString(rcon.command(args[4]));
                   System.out.println("# Success!");
                if (r.length()>0){
                 System.out.println("$ "+r);
                }
                   System.out.println("# Finish!");
               } catch (IOException ex) {
                 Logger.getLogger(HubsRCON.class.getName()).log(Level.SEVERE, null, ex);
               } catch (AuthenticationException ex) {
                 Logger.getLogger(HubsRCON.class.getName()).log(Level.SEVERE, null, ex);
               }
               break;
           default:
               System.out.println("# Error! Invalid arguments!");
               break;
       } 
     
    }
