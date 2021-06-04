<%-- 
    Document   : ticketMachine
    Created on : 13 Dec 2020, 16:20:47
    Author     : Cristiano Local
--%>

<%@page import="org.solent.com528.project.model.web.WebObjectFactory"%>
<%@page import="org.solent.com528.project.model.dao.PriceCalculatorDAO"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.*"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page import="org.solent.com528.project.model.dto.Ticket"%>
<%@page import="org.solent.com528.project.model.dto.Rate"%>
<%@page import="org.solent.com528.project.impl.dao.jaxb.PriceCalculatorDAOJaxbImpl"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="java.io.StringWriter"%>
<%@page import="javax.xml.bind.Marshaller"%>

<!DOCTYPE html>
<%
    // Setting up variables
    String startStation = request.getParameter("startStation");
    String endStation = request.getParameter("endStation");
    String ticketStr = request.getParameter("ticketStr");
    Integer startZone = 1;
    String endZoneStr = request.getParameter("endZoneStr");
    Integer zonesTravelled = 1;
    String errorMessage = "";
    Ticket newTicket = new Ticket();

    try {
        if (request.getParameter("startZone") != null) {
            startZone = Integer.parseInt(request.getParameter("startZone"));
        }
    } catch (Exception ex) {
        errorMessage = ex.getMessage() + request.getParameter("startZone");
    }

    try {
        if (request.getParameter("zonesTravelled") != null) {
            zonesTravelled = Integer.parseInt(request.getParameter("zonesTravelled"));
        }
    } catch (Exception ex) {
        errorMessage = ex.getMessage() + request.getParameter("zonesTravelled");
    }

    //Service    
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    List<Station> stationsList = new ArrayList<Station>();
    stationsList = stationDAO.findAll();
    String startStationStr = WebClientObjectFactory.getStationName();

    // Setting up Date/Time values
    Calendar newCalendar = Calendar.getInstance();
    newCalendar.setTime(new Date());
    newCalendar.add(Calendar.HOUR_OF_DAY, 4);
    String currentTime = new Date().toString();
    String validUntill = newCalendar.getTime().toString();

    String ticket = request.getParameter("ticketStr");

    // Getting the Price and Rate
    String fileName = "target/priceCalculatorDAOJaxbImplFile.xml";
    PriceCalculatorDAOJaxbImpl priceCalculatorDAOJaxb = new PriceCalculatorDAOJaxbImpl(fileName);
    PriceCalculatorDAO priceCalculatorDAO = serviceFacade.getPriceCalculatorDAO();
    priceCalculatorDAO.getPricingDetails();

    Rate rate = priceCalculatorDAOJaxb.getRate(new Date());
    Double pricePerZone = priceCalculatorDAOJaxb.getPricePerZone(new Date());
    double ticketPrice = 500.0;
    Integer totalZones = 1;

    //checking travelled zones
    int endZone = 0;
    try {
        endZone = Integer.parseInt(endZoneStr);
        totalZones = Math.abs(startZone - endZone);
        if (totalZones == 0) {
            totalZones = 1;
        }
        ticketPrice = pricePerZone * totalZones;
        newTicket.setCost(ticketPrice);
    } catch (Exception ex) {
        errorMessage = ex + "error with zones travelled";
    }

    // Setting up a new Ticket
    if (endStation != startStation) {
        newTicket.setRate(rate);
        newTicket.setStartStation(startStationStr);
        newTicket.setEndStation(endStation);
        newTicket.setIssueDate(new Date());

        String encodedTicket = TicketEncoderImpl.encodeTicket(newTicket);
        ticket = encodedTicket;
    } else if (endStation == startStation) {
        errorMessage = "start station cannot be the same as the destination station";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticket Machine</title>
        <style>               

            div {display: flex;
                 justify-content: center;}

            h1 {display: flex;
                justify-content: center;
                color: darkslateblue;
                font-family: "Times New Roman", Times, serif;
            }

            table {
                display: flex;
                justify-content: center;
            }
            button {             
                justify-content: center;
            }
            textArea {
                margin-left: auto;
                margin-right: auto;
            }

        </style>
    </head>
    <body>
        <h1>Create a New Ticket</h1>

        <div style="color:red;"><%=errorMessage%></div>

        <form action="./ticketMachine.jsp?zone=<%= endZone%>"  method="post">
            <table>
                <tr>
                    <td>Starting Station:</td>
                    <td><input type="text" name="startStation" value=""></td>
                </tr>
                <tr>
                    <td>Starting Zone:</td>
                    <td><input type="text" name="startZone"></td>
                </tr>
                <tr>
                    <td>Ending Station:</td>
                    <td><input type="text" name="endStation" value=""></td>     
                </tr>
                <tr>
                    <td>Ending Zone:</td>
                    <td><input type="text" name="endZoneStr"></td>      
                </tr>
<!--                <tr>
                    <td>Zones Travelled:</td>
                    <td><input type="text" name="zonesTravelled"></td>     
                </tr>-->
                <tr>
                    <td>Issued on:</td>
                    <td>
                        <p><%=currentTime%></p>
                    </td>
                </tr>
                <tr>
                    <td>Valid Until:</td>
                    <td>
                        <p><%=validUntill%></p>
                    </td>
                </tr>
                <tr>
                    <td><button type="submit" name="button" >Create Ticket</button></td>
                </tr>
            </table>

        </form> 
        <form action="index.html" name="home">
            <input type="submit" value="Return to index page" />
        </form>


        <h1>Generated ticket XML</h1>
        <div id="textArea">
            <textarea id="ticketTextArea" rows="14" cols="120"><%=ticket%></textarea>
        </div>

    </body>
</html>