// This script must be published in Google's "App Scripts"
// and its URL deployed in the "google_sheets_service.dart" file

var FOLDER_NAME = "APPGASTEI"; // nome da pasta onde a planilha será salva
var FILE_NAME = "Gastei_Dados"; // nome da planilha

function doGet(e) {
  return ContentService.createTextOutput("Script funcionando!");
}

function doPost(e) {
  var folder, files, spreadsheet;

  // verifica se a pasta já existe no Google Drive
  var folders = DriveApp.getFoldersByName(FOLDER_NAME);
  if (folders.hasNext()) {
    folder = folders.next();
  } else {
    folder = DriveApp.createFolder(FOLDER_NAME);
  }

  // verifica se a planilha já existe dentro da pasta
  files = folder.getFilesByName(FILE_NAME);
  if (files.hasNext()) {
    spreadsheet = SpreadsheetApp.open(files.next());
  } else {
    // se a planilha não existir, cria uma nova dentro da pasta
    spreadsheet = SpreadsheetApp.create(FILE_NAME);
    folder.addFile(DriveApp.getFileById(spreadsheet.getId()));

    // define cabeçalhos na primeira linha
    var sheet = spreadsheet.getActiveSheet();
    sheet.appendRow(["Categoria", "Valor", "Data"]);
  }

  var sheet = spreadsheet.getActiveSheet();

  // obtendo dados do app
  var category = e.parameter.category;
  var amount = e.parameter.amount;
  var date = e.parameter.date;

  // adicionando os dados à planilha
  sheet.appendRow([category, amount, date]);

  return ContentService.createTextOutput(
    JSON.stringify({
      result: "success",
      data: "Dados inseridos com sucesso na planilha fixa",
    })
  ).setMimeType(ContentService.MimeType.JSON);
}
