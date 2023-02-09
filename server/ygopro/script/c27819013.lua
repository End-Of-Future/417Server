--圣光裂变
function c27819013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c27819013.target)
	e1:SetOperation(c27819013.activate)
	c:RegisterEffect(e1)
end 
c27819013.SetCard_XXLight=true 
function c27819013.dsfil(c) 
	return c.SetCard_XXLight and c:IsFaceup() 
end 
function c27819013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c27819013.dsfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c27819013.dsfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c27819013.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(27819001)  
end  
function c27819013.activate(e,tp,eg,ep,ev,re,r,rp) 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c27819013.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(27819013,0)) then 
	Duel.BreakEffect() 
	local sg=Duel.SelectMatchingCard(tp,c27819013.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end



