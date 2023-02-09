--五王，永不言败
function c27819088.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)  
	--to deck and draw 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,27819088) 
	e2:SetTarget(c27819088.tddtg) 
	e2:SetOperation(c27819088.tddop) 
	c:RegisterEffect(e2) 
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,17819088) 
	e3:SetCondition(c27819088.spcon) 
	e3:SetTarget(c27819088.sptg)   
	e3:SetOperation(c27819088.spop) 
	c:RegisterEffect(e3) 
end 
c27819088.SetCard_fiveking=true
function c27819088.tdfil(c) 
	return c:IsAbleToDeck() and c.SetCard_fiveking   
end 
function c27819088.tddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c27819088.tdfil,tp,LOCATION_GRAVE,0,3,nil) end  
	local g=Duel.SelectTarget(tp,c27819088.tdfil,tp,LOCATION_GRAVE,0,3,3,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function c27819088.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then 
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end 
function c27819088.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)  
end 
function c27819088.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_fiveking  
end 
function c27819088.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c27819088.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end 
function c27819088.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27819088.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)  
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 










