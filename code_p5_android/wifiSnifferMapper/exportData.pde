void sendEmail() {
  Intent i = new Intent(Intent.ACTION_SEND);
  i.setType("message/rfc822");
  i.putExtra(Intent.EXTRA_EMAIL, new String[] {
    "mar.canet@gmail.com"
  }
  );
  i.putExtra(Intent.EXTRA_SUBJECT, "subject of email");
  i.putExtra(Intent.EXTRA_TEXT, "body of email");
  try {
    startActivity(Intent.createChooser(i, "Send mail..."));
  } 
  catch (android.content.ActivityNotFoundException ex) {
  }
}


