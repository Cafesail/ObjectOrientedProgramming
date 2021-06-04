package org.solent.com528.project.impl.rest;
import javax.ws.rs.ApplicationPath;
import org.glassfish.jersey.server.ResourceConfig;


@ApplicationPath("/rest")
public class RestApp extends ResourceConfig {
    public RestApp() {
        packages("org.solent.com528.project.impl.rest");
    }
}


// alternatve if using jaxrs directly
//public class RestApp extends Application {
//  public Set<Class<?>> getClasses() {
//    return new HashSet<Class<?>>(Arrays.asList(RestService.class));
//  }
//}