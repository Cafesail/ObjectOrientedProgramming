<%-- 
    Document   : gate
    Created on : 13 Dec 2020, 16:20:34
    Author     : Cristiano Local
--%>
<%@page import="java.util.Set"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="java.util.Calendar"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page import="org.solent.com528.project.model.dto.Ticket"%>
<%@page import="java.io.StringReader"%>
<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="java.io.StringWriter"%>
<%@page import="javax.xml.bind.Marshaller"%>

<%
    String errorMessage = "";
    String message = "";
    String ticketStr = request.getParameter("ticketStr");
    String endStation = null;
    response.setIntHeader("Refresh", 60);
    Date currentTime = new Date();
    Date issueDate = null;

    String zoneStr = request.getParameter("zoneInt");

    boolean validTime = false;
    boolean validFormat = false;
    boolean validStation = false;
    boolean openGate = false;

    //validating ticket XML data
    if (ticketStr != null) {
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance("org.solent.com528.project.model.dto");
            Unmarshaller jaxbUnMarshaller = jaxbContext.createUnmarshaller();
            Ticket ticket = (Ticket) jaxbUnMarshaller.unmarshal(new StringReader(ticketStr));
            issueDate = ticket.getIssueDate();
            endStation = ticket.getEndStation();
        } catch (Exception ex) {
            throw new IllegalArgumentException(ex + "could not marshall to Ticket ticketXML=" + ticketStr);
        }
    }

    // setting up date to check if ticket time within valid 4 hours
    try {
        Calendar newCalendar = Calendar.getInstance();
        newCalendar.setTime(issueDate);
        newCalendar.add(Calendar.HOUR_OF_DAY, 4);
        validTime = currentTime.before(newCalendar.getTime());
        if (!validTime) {
            errorMessage = "invalid time";
        }
    } catch (Exception e) {
        errorMessage = "couldnt validate time";
    }

    // checking if ticket is valid and opening gate
    validFormat = TicketEncoderImpl.validateTicket(ticketStr);
    if (!validFormat) {
        errorMessage = "invalid ticket format";
    }

    String endStationName = request.getParameter("endStationName");
    try {
        if (endStationName.equals(endStation)) {
            validStation = true;
        }
    } catch (Exception ex) {
        errorMessage = " Current Station must be the same as the end station in the ticket";
    }

    if (validFormat && validStation && validTime) {
        openGate = true;
        message = "Format, Date and Station all valid";
    } else {
        openGate = false;
        errorMessage = "Format, Date or Station not valid";
    }


%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gate Lock System</title>
        <style>   
            h1{
                display: flex;
                justify-content: center;
                color: darkslateblue;
                font-family: "Times New Roman", Times, serif;
            }
            img{
                margin-left: auto;
                margin-right: auto;
                width: 30%;
            }      
            div{
                display: flex;
                justify-content: center;
            }
            table{
                display: flex;
                justify-content: center;
            }
            .button {             
                justify-content: center;
                text-align: center;
            }


        </style>
    </head>
    <body>
        <h1>Open Gate with Ticket</h1>       
        <div id="img">
            <img src="images/gate.png" alt="gate" style="align-content: center">
        </div>
        <div style="color:red;"><%=errorMessage%></div> 
        <div style="color:green;"><%=message%></div>
        <form action="./gate.jsp"  method="post" >
            <table>
                <tr>
                    <td>Current Station: </td> 
                    <td><input type="text" name="endStationName"></td>
                </tr>
                <tr>
                    <td>Current Time</td>
                    <td>
                        <p><%= currentTime.toString()%> (auto refreshing every 60 seconds)</p>
                    </td>
                </tr>
                <tr>
                    <td>Ticket Data:</td>
                    <td><textarea name="ticketStr" rows="14" cols="90"><%=ticketStr%></textarea></td>

                </tr>
                <tr id="button">
                    <td><button  type="submit" >Open Gate</button></td>

                </tr>

            </table>

        </form>
        <form action="index.html">
            <input type="submit" value="Return to index page" />
        </form>

        <BR>
        <% if (openGate) { %>
        <% %>
        <div style="color:green;font-size:x-large">Valid Ticket, Gate Opening</div>              
        <%  } else {  %>
        <div style="color:red;font-size:x-large">Invalid Ticket, Gate will remain Closed</div>      
        <% }%>
    </body>
</html>
