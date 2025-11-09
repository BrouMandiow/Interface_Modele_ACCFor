#Interface utilisateur
#Pour créer un programme R qui prend des inputs utilisateur et fournit une valeur prédite d'albédo en utilisant votre modèle, voici les étapes principales :
#1. Prérequis
#- Assurez-vous que le modèle entraîné (par exemple, model) est sauvegardé ou accessible dans votre environnement R.
#- Préparez une interface pour que l'utilisateur puisse fournir les valeurs des variables nécessaires (par exemple, latitude, température, etc.).
#2. Structure de Base
#Voici une structure pour le script R qui intègre une interaction utilisateur :

###################################
# Application Shiny : Prédiction de l'Albédo
###################################

# Chargement des bibliothèques
library(shiny)
library(shinythemes)
library(randomForest)
library(dplyr)

# Chargement du modèle
model_url <- "https://drive.google.com/uc?export=download&id=1mtCjSi703k8hLExLyMddQWVLB1Lzvzcr"
model_path <- "rf_model_test3_local.rds"

if (!file.exists(model_path)) {
  download.file(model_url, destfile = model_path, mode = "wb")
}

model <- readRDS(model_path)

# Fonction de prédiction
predict_albedo <- function(input_data) {
  tryCatch({
    predict(model, newdata = input_data)
  }, error = function(e) {
    NA
  })
}

# Interface utilisateur
ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Prédiction de l'Albédo"),

  sidebarLayout(
    sidebarPanel(
      h4("Entrées numériques"),
      numericInput("latitude", "Latitude :", value = 48, step = 0.00000001),
      numericInput("nbjr_neige5", "Nombre de jours de neige :", value = 15, step = 1),
      numericInput("mois", "Mois :", value = 6, step = 1),
      numericInput("t_18_c", "Température moyenne à 18h °C :", value = 0, step = 0.01),
      numericInput("hauteur", "Hauteur (mètres) :", value = 15, step = 1),

      h4("Entrées catégoriques"),
      selectInput("type_eco", "Type écologique :", c("FE10", "FE11", "FE12",
          "FE13", "FE14", "FE15", "FE16", "FE20",
          "FE21", "FE22", "FE23", "FE24", "FE25", "FE26", "FE30", "FE31",
          "FE32", "FE32H", "FE35", "FE42", "FE50", "FE51", "FE52", "FE60",
          "FE61", "FE62", "FO14", "FO15", "FO16", "FO18", "FC10", "FC12",
          "MA18R", "MF14", "MF15", "MF16", "MF18", "MJ10", "MJ11", "MJ12",
          "MJ13", "MJ14", "MJ15", "MJ16", "MJ18", "MJ20", "MJ21", "MJ22",
          "MJ23", "MJ24", "MJ25", "MJ26", "MS11", "MS12", "MS14", "MS15",
          "MS18", "MS20", "MS21", "MS22", "MS23", "MS24", "MS25", "MS26",
          "MS40", "MS42", "MS60", "MS61", "MS62", "MS63", "MS64", "MS65",
          "MS66", "RB10", "RB11", "RB12", "RB13", "RB14", "RB15", "RB16",
          "RC38", "RE20", "RE21", "RE22", "RE24", "RE25", "RE37", "RE38",
          "RE39", "RP10", "RP11", "RP12", "RP13", "RP14", "RP15", "RS10",
          "RS11", "RS12", "RS13", "RS14", "RS15", "RS16", "RS18", "RS20",
          "RS21", "RS22", "RS22M", "RS23", "RS24", "RS25", "RS25S", "RS26",
          "RS37", "RS38", "RS39", "RS50", "RS51", "RS52", "RS54", "RS55",
          "TOB9D", "TOB9U", "TOF8U", "unknown")),
      selectInput("co_ter", "Cote terrain :", c("A", "AF", "AL", "ANT", "DH", "DS", "EAU", "GR", "ILE", "INO", 
                    "LTE", "NF", "NX", "RO", "TNP", "unknown")),
      selectInput("cl_pent", "Classe de pente :", c("A", "B", "C", "D", "E", "F", "S", "unknown")),
      selectInput("dep_sur", "Dépôt de surface :", c(
          "1A", "1AA", "1AB", "1AD", "1AM", "1AY", "1BF", "1BI", "1BP", "1BC",
          "1BG", "1BD", "2A", "2AE", "2AK", "2AT", "2BD", "2BE", "3AC", "3AE",
          "3AN", "3D", "4A", "4GA", "4GD", "4GS", "5A", "5AM", "5AY", "5L",
          "5S", "5SY", "6A", "6S", "6SY", "7E", "7T", "7TM", "7TY", "8A",
          "8AY", "8AM", "8C", "8CM", "8CY", "8E", "8F", "8G", "9S", "9SY",
          "M1A", "M8A", "R", "R1A", "R4G", "R5A", "R5S", "R7T", "R8A", "R8C",
          "unknown")),
      selectInput("cl_drai", "Classe de drainage :", c("0", "10", "11", "16", "20", "21", "30", "31", "33", "40", "41", 
          "43", "44", "50", "51", "53", "60", "61", "63", "unknown")),
      selectInput("type_couv", "Type de couverture :", c("F", "M", "R", "unknown")),
      selectInput("cl_dens", "Classe de densité :", c("A", "B", "C", "D", "H", "unknown")),
      selectInput("cl_haut", "Classe de hauteur :", c("1", "2", "3", "4", "5", "6", "7", "unknown")),
      selectInput("cl_age", "Classe d'âge :", c("10", "10JIN", "1050", "1070", "120", "12010", "12030", "12050",
          "12070", "12090", "120JI", "120VI", "120.0", "30", "30.0", "30VIN",
          "3010", "30120", "3030", "3050", "3070", "3090", "5010", "50120",
          "5030", "5050", "5070", "5090", "50", "70", "70.0", "7010", "70120",
          "7030", "7050", "7070", "7090", "90", "90.0", "9010", "90120", "9050",
          "9070", "9090", "JIN", "JIN10", "JIN12", "JIN30", "JIN70", "JIR", 
          "VIN", "VIN10", "VIN12", "VIN30", "VIN50", "VINJI", "VIR", "unknown")),

      actionButton("predict", "Prédire l'Albédo", class = "btn-primary btn-lg btn-block")
    ),

    mainPanel(
      h3("Résultats de la Prédiction"),
      wellPanel(textOutput("result")),
      h3("Résumé des Données Saisies"),
      wellPanel(tableOutput("input_summary"))
    )
  )
)

# Serveur
server <- function(input, output) {
  values <- reactiveValues(prediction = NULL, input_data = NULL)

  observeEvent(input$predict, {
    # Validation des entrées
    if (!is.numeric(input$latitude) || !is.numeric(input$t_18_c)) {
      showNotification("Latitude et température doivent être numériques.", type = "error")
      return()
    }
    if (input$mois %% 1 != 0 || input$hauteur %% 1 != 0 || input$nbjr_neige5 %% 1 != 0) {
      showNotification("Mois, hauteur et jours de neige doivent être des entiers.", type = "error")
      return()
    }

    # Création du jeu de données
    new_data <- data.frame(
      LATITUDE = input$latitude,
      nbjr_neige5 = input$nbjr_neige5,
      mois = input$mois,
      t_18_c = input$t_18_c,
      TYPE_ECO = input$type_eco,
      CO_TER = input$co_ter,
      CL_PENT = input$cl_pent,
      DEP_SUR = input$dep_sur,
      CL_DRAI = input$cl_drai,
      TYPE_COUV = input$type_couv,
      CL_DENS = input$cl_dens,
      CL_HAUT = input$cl_haut,
      CL_AGE = input$cl_age,
      HAUTEUR = input$hauteur
    )

    values$input_data <- new_data
    values$prediction <- predict_albedo(new_data)
  })

  output$input_summary <- renderTable({
    req(values$input_data)
    data.frame(Variable = names(values$input_data), Valeur = unlist(values$input_data))
  })

  output$result <- renderText({
  req(values$prediction)
  if (is.na(values$prediction)) {
    "Erreur lors de la prédiction."
  } else {
    sprintf("La valeur prédite de l'albédo est : %.3f", values$prediction)
  }
})

}

# Lancer l'application
shinyApp(ui = ui, server = server)
