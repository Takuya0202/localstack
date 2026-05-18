package com.example.lambda_container;

import java.util.Map;
import java.util.function.Function;

import org.springframework.stereotype.Component;

@Component
public class HelloSpringFunction implements Function<String, Map<String, String>> {
    @Override
    public Map<String, String> apply(String input) {
        return Map.of("message", "Hello , Spring");
    }

}
