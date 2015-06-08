import java.net.*;
import java.io.*;
import java.util.*;

public class Client {
  private final String serverAddress = "127.0.0.1";
  private final int port = 55564;

  private PrintWriter out;
  private BufferedReader in;
  private Socket serverSocket;
  public Client() {
  }

  public boolean setupClient() {
    serverSocket = null; // Sets up the socket, out and in variables                                                                                                                             
    out = null;
    in = null;

    try {
      serverSocket = new Socket(serverAddress, port);
      out = new PrintWriter(serverSocket.getOutputStream(), true);
      in = new BufferedReader(new InputStreamReader(serverSocket.getInputStream()));
      return true;
    }
    catch (UnknownHostException e) {
      e.printStackTrace();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    return false;
  }

  public boolean closeServer() {
    try {
      in.close();    
      serverSocket.close();
      return true;
    }
    catch (IOException e) {
      e.printStackTrace(); // Exception handling
    }
    return false;
  }

  public boolean sendMessage(String msg) {
    try {
      out.println(msg);
      String input = "";
      while ( (input = in.readLine ()) == null) {
      }
      if (input.equals("success")) {
        return true;
      } else {
        return false;
      }
    }
    catch (IOException e) {
      return false;
    }
  }

  public String recieveInformation(String msg) {
    try {
      out.println(msg);
      String input = "";
      while ( (input = in.readLine ()) == null) {
      }
      return input;
    }
    catch (IOException e) {
      return "-1";
    }
  }
}

