/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author maria
 */
import java.text.NumberFormat;
public class Product {
    //instance variables --
    private String code;
    private String description;
    private double price;
    
    //the constructor (default constuctor) 
    public Product(){
        code = "";
        description = "";
        price = 0;
    }
    /*
    constructor with 3 parameters
    public Product(String code, String description, double price){
        this.code = code;
        this.description = description;
        this.price = price;
    }
    */
    //set and get methods for code var
    public void setCode(String code){
        this.code = code;
    }
    public String getCode(){
        return code;
    }
    
    //set and get methods for description var
    public void setDescription(String description){
        this.description = description;
    }
    public String getDescription(){
        return description;
    }
    
    //set and get methods for price var
    public void setPrice(double price){
        this.price = price;
    }
    public double getPrice(){
        return price;
    }
    //custom method for price var
    public String getPriceFormatted(){
        NumberFormat currency = NumberFormat.getCurrencyInstance();
        String priceFormatted = currency.format(price);
        return priceFormatted;
    }
}
