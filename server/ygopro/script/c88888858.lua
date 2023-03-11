--讳言巨龙 迦拉克隆
function c88888858.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,88888858+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c88888858.accon)  
	e1:SetTarget(c88888858.actg) 
	e1:SetOperation(c88888858.acop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCountLimit(1) 
	e2:SetCost(c88888858.fthcost)
	e2:SetTarget(c88888858.fthtg) 
	e2:SetOperation(c88888858.fthop)  
	c:RegisterEffect(e2) 
	c88888858.field_effect=e2 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_LEAVE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c88888858.thtg) 
	e3:SetOperation(c88888858.thop) 
	c:RegisterEffect(e3) 
	--to hand 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_SUMMON_SUCCESS) 
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetRange(LOCATION_GRAVE) 
	e4:SetCountLimit(1,18888858+EFFECT_COUNT_CODE_DUEL) 
	e4:SetTarget(c88888858.xthtg) 
	e4:SetOperation(c88888858.xthop) 
	c:RegisterEffect(e4) 
	local e5=e4:Clone() 
	e5:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e5) 
	local e6=e4:Clone() 
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
	c:RegisterEffect(e6)  
end
c88888858.SetCard_A_jlcl=true 
function c88888858.ackfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) 
end 
function c88888858.accon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c88888858.ackfil,tp,LOCATION_MZONE,0,1,nil) 
end  
function c88888858.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=0 
	if Duel.GetFlagEffect(tp,88888858)==0 then x=1 end 
	if Duel.GetFlagEffect(tp,88888858)==1 then x=2 end 
	if Duel.GetFlagEffect(tp,88888858)>=2 then x=3 end 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,x,nil) end   
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888858,5))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888858,5))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,x,1-tp,LOCATION_ONFIELD) 
end 
function c88888858.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local x=0 
	if Duel.GetFlagEffect(tp,88888858)==0 then x=1 end 
	if Duel.GetFlagEffect(tp,88888858)==1 then x=2 end 
	if Duel.GetFlagEffect(tp,88888858)>=2 then x=3 end 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>=x then 
	local dg=g:RandomSelect(tp,x) 
	Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 
function c88888858.fthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c88888858.fthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888858,6))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888858,6))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK) 
end 
function c88888858.fthop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_DECK,nil)
	if g:GetCount()>0 then 
	local sg=g:RandomSelect(tp,1) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end 
function c88888858.thfil(c) 
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()  
end 
function c88888858.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c88888858.thfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888858,7))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888858,7))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_MZONE) 
end  
function c88888858.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88888858.thfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end
function c88888858.xthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end  
function c88888858.xthop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 















