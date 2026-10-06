package com.travelrecommdations;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableAsync;





@SpringBootApplication
@ComponentScan(basePackages = "com.travelrecommdations")
@EnableAsync
public class TravelRecommandationSystemApplication extends SpringBootServletInitializer  {

	
	@Override protected SpringApplicationBuilder configure( SpringApplicationBuilder application) { return application.sources( TravelRecommandationSystemApplication.class );
	}
	public static void main(String[] args) {
		SpringApplication.run(TravelRecommandationSystemApplication.class, args);
	}
	
	

}
