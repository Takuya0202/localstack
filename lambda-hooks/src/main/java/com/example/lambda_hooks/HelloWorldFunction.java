package com.example.lambda_hooks;

import java.util.Map;
import java.util.function.Function;

import org.springframework.stereotype.Component;

@Component
public class HelloWorldFunction implements Function<String, Map<String, String>> {
    @Override
    public Map<String, String> apply(String input) {
        return Map.of("message", "hello , world");
    }
}
