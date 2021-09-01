unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin, ComCtrls, HTTPSend, ssl_openssl, RegExpr, ftpsend, synautil, smtpsend, mimemess, pop3send, blcksock, mimepart, synachar, Types;

type

  Toperation=(orien, oaddition, osoustraction, omultiplication, odivision);
  ESMTP = class (Exception);

  { TStage }

  TStage = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button2: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit7: TEdit;
    Effacer: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    FTP: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ProgressBar1: TProgressBar;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure EffacerClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure ProgressBar1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure RadioButton1Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    //procedure MailSend(const sSmtpHost, sSmtpPort, sSmtpUser, sSmtpPasswd, sFrom, sTo, sFileName: AnsiString);

  private
     aoperation:toperation;
     resultat:integer;
     flag:boolean;
     aftp : TFTPsend;
     http : THTTPSend;

     procedure AddToLog(str:string);
  public
     procedure Generique(valeur: integer);
  end;

var
  Stage: TStage;
  jpg: TJPEGImage;
  aPNG: TPortableNetworkGraphic;
  aGIF: TGIFImage;
  SMTP: TSMTPSend;
  msg_lines: TStringList;
  aString: string;
  sendOK: boolean;


implementation

{$R *.lfm}

{ TStage }

procedure TStage.Button1Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'1';
  Generique(1);
end;

procedure TStage.Button20Click(Sender: TObject);
begin
  try
    if http.HTTPMethod('GET','https://www.peintures1825.fr/wp-content/uploads/2018/04/1998_1-1.jpg') then
    //https://www.lapiattaformadellavoro.it/wp-content/uploads/2018/03/6-300x225.jpg
    begin
      jpg:= TJPEGImage.Create;
      try
        jpg.Clear;
        Image1.Picture.Graphic := jpg;
      finally
        jpg.Free;
      end;
    end;
  except
    on E : Exception do
      ShowMessage(E.ClassName+' : '+E.Message);
  end;
end;

procedure TStage.Button23Click(Sender: TObject);
begin

end;

procedure TStage.Button24Click(Sender: TObject);
var
  strs: tstrings;
  def : string;
  m: TMimemess;
  p: TMimepart;
begin

  strs := TStringList.Create;
  try
    strs.Add('<body>' + (edit4.text) + '</body>');
    m:=TMimemess.create;
    try
      p := m.AddPartMultipart('mixed', nil);
      m.AddPartHTML(strs, p);
      m.header.from := Edit3.Text;
      m.header.tolist.add(Edit5.Text);
      m.header.subject:=Edit7.Text;
      m.EncodeMessage;


  smtp := TSMTPSend.Create;
  try
    smtp.UserName := Edit3.Text;
    def := '';
    if InputQuery('Mot de passe', 'Mot de passe :', True, def) then
       smtp.Password := def;

    smtp.TargetHost := 'SMTP.office365.com';
    //smtp.FullSSL:=True;         
    smtp.AutoTLS:=True;
    smtp.TargetPort := '587';

    AddToLog('EMAIL BON !');
    if not smtp.Login() then
    //begin
      //addtolog('echec login:' + smtp.EnhCodeString);
      //exit;
    //end;
    (*
    AddToLog('SMTP StartTLS');
    if not smtp.StartTLS() then
    begin
      addtolog('echec StartTLS:' + smtp.EnhCodeString);
      exit;
    end;
    *)

    AddToLog('SMTP Mail');
    if not smtp.MailFrom(Edit3.Text, Length(Edit3.Text)) then
    begin
      addtolog('Problème :(' + smtp.EnhCodeString);
      exit;
    end;
    if not smtp.MailTo(Edit5.Text) then
    begin
      addtolog('echec To:' + smtp.EnhCodeString);
      exit;
    end;
    if not smtp.MailData(m.Lines) then
    begin
      addtolog('echec msg_lignes:' + smtp.EnhCodeString);
      exit;
    end;
    AddToLog('EMAIL ENVOYER !');
    if not smtp.Logout() then
    begin
      addtolog('echec Logout:' + smtp.EnhCodeString);
      exit;
    end;

    AddToLog('EMAIL RECU !');
  finally
    smtp.Free;
  end;
        
  finally 
    p.free;
    m.free;
  end;
  finally
    strs.Free;
  end;

(*
begin
  Result:=False;
  m:=TMimemess.create;
  try
    p := m.AddPartMultipart('mixed', nil);
    m.AddPartHTML('test', p);
    m.header.from := 'toronico07@outlook.fr';
    m.header.tolist.add('toronicolas07@gmail.com');
    m.header.subject:='Message from my system';
    m.EncodeMessage;*)
end;

procedure TStage.Button25Click(Sender: TObject);
begin
  if ftpGetFile('<domain_or_ip>','21','<remote_file_name_plus_path>',
                     '<target_filename_plus_path>',
                     '<username>','<password>') then
    writeln('succes') else writeln('fail');
  readln;
end;



procedure TStage.Button26Click(Sender: TObject);
begin
  try
    if http.HTTPMethod('GET','https://media1.giphy.com/media/gw3IWyGkC0rsazTi/giphy.gif?cid=790b76110d179acb0d7bce47b6b19b79ab2a50c041b8304d&rid=giphy.gif') then
    begin
      agif:= TGIFImage.Create;
      try
        agif.LoadFromStream(http.Document);
        Image3.Picture.Graphic := agif;
      finally
        agif.Free;
      end;
    end;
  except
    on E : Exception do
      ShowMessage(E.ClassName+' : '+E.Message);
  end;
end;

procedure TStage.Button27Click(Sender: TObject);
begin
  try
     if http.HTTPMethod('GET','https://media1.giphy.com/media/gw3IWyGkC0rsazTi/giphy.gif?cid=790b76110d179acb0d7bce47b6b19b79ab2a50c041b8304d&rid=giphy.gif') then
    begin
      agif:= TGIFImage.Create;
      try
        agif.Clear;
        Image3.Picture.Graphic := agif;
      finally
        agif.Free;
      end;
    end;
  except
    on E : Exception do
      ShowMessage(E.ClassName+' : '+E.Message);
  end;
end;

procedure TStage.Button2Click(Sender: TObject);
begin
  try
    if http.HTTPMethod('GET','https://upload.wikimedia.org/wikipedia/commons/d/db/Patern_test.jpg') then
    begin
      jpg:= TJPEGImage.Create;
      try
        jpg.LoadFromStream(http.Document);
        Image1.Picture.Graphic := jpg;
      finally
        jpg.Free;
      end;
    end;
  except
    on E : Exception do
      ShowMessage(E.ClassName+' : '+E.Message);
  end;
end;

procedure TStage.Edit4Change(Sender: TObject);
begin

end;

procedure TStage.EffacerClick(Sender: TObject);
begin
  Edit1.Text:= '0';
  Edit2.Text:= '0';
  resultat :=0;
  aoperation:=orien;
end;

procedure TStage.Button10Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'9';
  Generique(9);
  //aoperation:=oRien;
end;

procedure TStage.Button11Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'0';
  Generique(0);
end;

procedure TStage.Button12Click(Sender: TObject);
begin
  //Edit2.Text:=inttostr(StrToInt(Edit1.Text)+ StrToInt(Edit3.Text));
  aoperation:=oaddition;
  resultat:=StrToInt(edit1.text);

  flag :=true;
end;

procedure TStage.Button13Click(Sender: TObject);
begin
  //Edit2.Text:=inttostr(StrToInt(Edit1.Text) * StrToInt(Edit3.Text));
  aoperation:=omultiplication;
  resultat:=StrToInt(edit1.text);
  flag :=true;
end;

procedure TStage.Button14Click(Sender: TObject);
begin
  //Edit2.Text:=inttostr(StrToInt(Edit1.Text) - StrToInt(Edit3.Text));
  aoperation:=osoustraction;
  resultat:=StrToInt(edit1.text);
  flag :=true;
end;

procedure TStage.Button15Click(Sender: TObject);
begin
  ///Edit2.Text:=inttostr(StrToInt(Edit1.Text) div StrToInt(Edit1.Text));
  aoperation:=odivision;
  resultat:=StrToInt(Edit1.Text);
  flag :=true;
end;

procedure TStage.Button3Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'2';
  Generique(2);
  ///aoperation:=orien;
end;

procedure TStage.Button4Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'4';
  Generique(4);
  ///aoperation:=orien;
end;

procedure TStage.Button5Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'3';
  Generique(3);
  ///aoperation:=orien;
end;

procedure TStage.Button6Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'6';
  Generique(7);
  ///aoperation:=orien;
end;

procedure TStage.Button7Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'6';
  Generique(6);
  ///aoperation:=orien;
end;

procedure TStage.Button8Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'5';
  Generique(5);
  ///aoperation:=orien;
end;

procedure TStage.Button9Click(Sender: TObject);
begin
  //Edit1.Text:=Edit1.Text +'8';
  Generique(8);
  ///aoperation:=orien;
end;

procedure TStage.Button17Click(Sender: TObject);
begin

end;

procedure TStage.Button21Click(Sender: TObject);
begin
  try
    if http.HTTPMethod('GET','https://image.flaticon.com/icons/png/512/1039/1039328.png') then
    begin
      apng:= TPortableNetworkGraphic.Create;
      try
        apng.LoadFromStream(http.Document);
        Image2.Picture.Graphic := apng;
      finally
        apng.Free;
      end;
    end;
  except
    on E : Exception do
      ShowMessage(E.ClassName+' : '+E.Message);
  end;
end;

procedure TStage.Button22Click(Sender: TObject);
begin
  try
    if http.HTTPMethod('GET','https://image.flaticon.com/icons/png/512/1039/1039328.png') then
    begin
      apng:= TPortableNetworkGraphic.Create;
      try
        apng.clear;
        Image2.Picture.Graphic := apng;
      finally
        apng.Free;
      end;
    end;
  except
    on E : Exception do
      ShowMessage(E.ClassName+' : '+E.Message);
  end;
end;

procedure TStage.Edit1Change(Sender: TObject);
begin

end;

procedure TStage.Edit2Change(Sender: TObject);
begin
end;

procedure TStage.Edit3Change(Sender: TObject);
begin

end;

procedure TStage.FormCreate(Sender: TObject);
begin
  Edit2.text :='0';
  flag :=false;
  aftp := TFTPSend.Create;
  http := THTTPSend.Create;
  //Ne pas supprimer (https://lazarus.developpez.com/cours/serge-arbiol/lazarus-utiliser-composant-tmplayercontrol/)
  //var
    //FormatsVideo,
    //FormatsAudio : String;
    //FormatsVideo:='*.MP4,*.mp4,*.MP3,*.mp3';
end;

procedure TStage.FormDestroy(Sender: TObject);
begin
  http.Free;
end;

procedure TStage.GroupBox2Click(Sender: TObject);
begin

end;

procedure TStage.Label2Click(Sender: TObject);
begin

end;

procedure TStage.ProgressBar1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TStage.RadioButton1Change(Sender: TObject);
begin

end;

procedure TStage.SpinEdit1Change(Sender: TObject);
begin

end;

procedure TStage.AddToLog(str: string);
begin
  showmessage(str);
end;

procedure TStage.Generique(valeur: integer);
begin

  if Edit1.Text = '0' then Edit1.Text := '';
  case aoperation of
       oRien:Edit1.Text:= Edit1.Text + IntToStr (valeur);
       oAddition:
         begin
           if flag = false then
           begin
                Edit1.Text:= Edit1.Text + IntToStr (valeur);
           end
           else
         begin
                Edit1.Text:= IntToStr (valeur);
                flag := false;
           end;
           Edit2.Text:= IntToStr(resultat + StrToInt(Edit1.Text));
           ///Edit2.Text:= IntToStr((valeur) + StrToInt(Edit1.Text));

         end;
       oSoustraction:
         begin
           if flag = false then
           begin
                //Edit1.Text:= inttostr(StrToInt(Edit1.Text) + (valeur));
                Edit1.Text:= Edit1.Text + IntToStr (valeur);
           end
           else
           begin
                Edit1.Text:= IntToStr (valeur);
                flag := false;
           end;
           Edit2.Text:= IntToStr(resultat - StrToInt(Edit1.Text));
         //  if flag = false then
         //  begin
         //       Edit1.Text:= IntToStr (valeur) + Edit1.Text;
         //  end
         //  else
         //  begin
         //       Edit1.Text:= IntToStr (valeur);
         //       flag := false;
         //  end;
         //  Edit2.Text:= IntToStr(strtoint(Edit1.Text) - resultat)
         end;
       oMultiplication:
         begin
           if flag = false then
           begin
                Edit1.Text:= Edit1.Text + IntToStr (valeur);
           end
           else
           begin
                Edit1.Text:= IntToStr (valeur);
                flag := false;
           end;
           Edit2.Text:= IntToStr(resultat * StrToInt(Edit1.Text));
         end;
       oDivision:

         begin
           if flag = false then
           begin
                Edit1.Text:= Edit1.Text + IntToStr (valeur);
                //IntToStr((valeur) div resultat)
           end
           else
           begin
                Edit1.Text:= IntToStr (valeur);
                flag := false;
           end;
           Edit2.Text:= IntToStr(resultat div StrToInt(Edit1.Text));

         end;
  end;

  ///aoperation:=orien;
end;

//procedure TStage.SockPutCallBack(Sender: TObject;
  //Reason: THookSocketReason; const Value: string);
//begin
  //case Reason of
    //HR_WriteCount:
      //begin
        //inc(CurrentBytes, StrToIntDef(Value, 0));
        //ProgressBar.Position := Round(1000 * (CurrentBytes / TotalBytes));
      //end;
    //HR_Connect: CurrentBytes := 0;
  //end;
//end;


end.

