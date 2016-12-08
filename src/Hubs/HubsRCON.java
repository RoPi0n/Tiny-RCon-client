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
     return "Hubs.RCon comand does'n t exist!";
    }
    
    public static String ParseMCResultString(String s){
     while(s.contains("§"))
     {
      s=s.substring(0,s.indexOf("§"))+s.substring(s.indexOf("§")+2);
     }   
      s.replaceAll("\n\n","\n");
      return s;  
    }
    
    public static void main(String[] args) {
      if (args.length==0)
       {
        System.out.println("Hubs soft.\nAutor: pavel151\nMail: pavel151@inbox.ru\nUse: <HubsRCON> <IP> <PORT> <PASSWORD>");
        System.exit(0);
       }
        Scanner sc = new Scanner(System.in);
        try {
            Rcon rcon=new Rcon(args[0], Integer.parseInt(args[1]), args[2].getBytes());
            System.out.println("Hubs.RCON connected to "+args[0]+":"+args[1]+" successful!");
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
    
}
