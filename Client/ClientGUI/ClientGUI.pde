import controlP5.*;
import javax.swing.*;
import java.nio.file.Paths;

private Textfield username, password;

ControlP5 c;

boolean onUsername;

Client client;

void setup() {
  client = null;

  size(300, 300);
  c = new ControlP5(this);

  username = c.addTextfield("username").setPosition(50, 50).setSize(200, 20).setFocus(true).setId(1).setAutoClear(false);
  password = c.addTextfield("password").setPosition(50, 150).setSize(200, 20).setId(2).setPasswordMode(true).setAutoClear(false);

  c.addTextlabel("usernameText").setText("Username").setPosition(125, 25).setColor(0);
  c.addTextlabel("passwordText").setText("Password").setPosition(125, 125).setColor(0);

  c.addButton("login").setValueLabel("Login").setPosition(50, 250).setSize(75, 20).setId(3);
  c.addButton("create").setValueLabel("Create account").setPosition(175, 250).setSize(75, 20).setId(4);

  onUsername = true;  

  client = new Client();

  if (!client.setupClient()) {
    errorMessage("The server was not found, it might be down, try again later.");
    exit();
  }

}

void draw() {
  background(255);
}

void keyPressed() {
  if (keyCode == 9) { // is tab, switch the focus
    if (onUsername) {
      password.setFocus(true);
      username.setFocus(false);
      onUsername = false;
    } else {
      username.setFocus(true);
      password.setFocus(false);
      onUsername = true;
    }
  }
}

public void login(String u, String p) {
  if (client.sendMessage("login " + u + " " + p)) {
    openMainWindow();
  } else {
    errorMessage("Incorrect username or password");
  }
}

public void create(String u, String p) {
  if (client.sendMessage("create " + u + " " + p)) {
    openMainWindow();
  } else {
    errorMessage("That username is already in use.");
  }
}

public void controlEvent(ControlEvent e) {
  if (e.getController().getId() == 3) {
    if (!password.getText().equals("")) {
      login(username.getText(), password.getText());
      password.setText("");
    } else {
      errorMessage("No blank passwords allowed");
    }
  }
  if (e.getController().getId() == 1) {
    if (!password.getText().equals("")) {
      login(username.getText(), password.getText());
      password.setText("");
    } else {
      errorMessage("No blank passwords allowed");
    }
  }
  if (e.getController().getId() == 2) {
    if (!password.getText().equals("")) {
      login(username.getText(), password.getText());
      password.setText("");
    } else {
      errorMessage("No blank passwords allowed");
    }
  } else if (e.getController().getId() == 4) {
    if (!password.getText().equals("")) {
      create(username.getText(), password.getText());
      password.setText("");
    } else {
      errorMessage("No blank passwords allowed");
    }
  }
}

public void errorMessage(String e) {
  JOptionPane.showMessageDialog(new JFrame(), e, "Error", JOptionPane.ERROR_MESSAGE);
}

public void stop() {
  client.sendMessage("logout");
  exit();
} 

public void openMainWindow() {
  MainWindow m = new MainWindow(client, this);
  this.frame.hide();
}

