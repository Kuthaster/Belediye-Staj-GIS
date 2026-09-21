package com.kutalmis.cografi_nesne_takip.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ObjectNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ObjectNotFoundException ex) {
        ErrorResponse body = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.NOT_FOUND.value(),
                ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(body);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex) {
        ErrorResponse body = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Beklenmedik bir hata oluştu.");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }

    @ExceptionHandler(WrongObjectTypeException.class)
    public ResponseEntity<ErrorResponse> handleWrongType(WrongObjectTypeException ex) {
        ErrorResponse body = new ErrorResponse(LocalDateTime.now(), HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(RequiredFieldMissingException.class)
    public ResponseEntity<ErrorResponse> handleRequiredFieldMissing(RequiredFieldMissingException ex) {
        ErrorResponse body = new ErrorResponse(LocalDateTime.now(), HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
                .map(err -> err.getField() + ": " + err.getDefaultMessage())
                .collect(Collectors.joining(", "));
        ErrorResponse body = new ErrorResponse(LocalDateTime.now(), HttpStatus.BAD_REQUEST.value(), message);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgument(IllegalArgumentException ex) {
        ErrorResponse body = new ErrorResponse(LocalDateTime.now(), HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ErrorResponse> handleBadCredentials(BadCredentialsException ex) {
        ErrorResponse body = new ErrorResponse(LocalDateTime.now(), HttpStatus.UNAUTHORIZED.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
    }

    @ExceptionHandler(InvalidFileTypeException.class)
    public ResponseEntity<ErrorResponse> handleInvalidFileType(InvalidFileTypeException ex) {
        ErrorResponse error = new ErrorResponse(
                LocalDateTime.now(ZoneOffset.UTC),
                HttpStatus.BAD_REQUEST.value(),
                ex.getMessage());
        return ResponseEntity.badRequest().body(error);
    }

    @ExceptionHandler(PhotoNotFoundException.class)
    public ResponseEntity<ErrorResponse> handlePhotoNotFound(PhotoNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(
                LocalDateTime.now(ZoneOffset.UTC),
                HttpStatus.NOT_FOUND.value(),
                ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(NoPreviousPhotoException.class)
    public ResponseEntity<ErrorResponse> handleNoPreviousPhoto(NoPreviousPhotoException ex) {
        ErrorResponse error = new ErrorResponse(
                LocalDateTime.now(ZoneOffset.UTC),
                HttpStatus.BAD_REQUEST.value(),
                ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

}